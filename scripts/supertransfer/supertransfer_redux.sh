############################################################################
# INIT
############################################################################
source rcloneupload.sh
source init.sh
source settings.conf
source /opt/appdata/plexguide/supertransfer/usersettings.conf
#dbug=on

# check to make sure filepaths are there
[[ -e $gdsaDB ]] || touch $gdsaDB
[[ -e $uploadHistory ]] || touch $uploadHistory
[[ -d $jsonPath ]] || mkdir $jsonPath
[[ -d $logDir ]] || mkdir $logDir
[[ ! -e $userSettings ]] && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo User settings found in $userSettings. Exiting." && exit 1


init_DB(){
  # [[ $gdsaImpersonate == 'your@email.com' ]] \
  #   && echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\tNo Email Configured. Please edit $userSettings" \

  # get list of avail gdsa accounts
  gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
  if [[ -n $gdsaList ]]; then
      numGdsa=$(echo $gdsaList | wc -w)
      maxDailyUpload=$(python3 -c "print(round($numGdsa * 750 / 1000, 3))")
      echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tInitializing $numGdsa Service Accounts:\t${maxDailyUpload}TB Max Daily Upload"
#      echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tValidating Domain Wide Impersonation:\t$gdsaImpersonate"
  else
      echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Valid SA accounts found! Is Rclone Configured With GDSA## remotes?"
      exit 1
  fi

  # reset existing logs & db
  echo '' > /tmp/SA_error.log
  #echo '' > $gdsaDB
  # test for working gdsa's and init gdsaDB
  for gdsa in $gdsaList; do
    s=0
    rclone touch ${gdsa}:/SA_validate &>/tmp/.SA_error.log.tmp && s=1
    if [[ $s == 1 ]]; then
      echo -e "[$(date +%m/%d\ %H:%M)] [ OK ]\t${gdsa}\t Validation Successful!"
      egrep -q ^${gdsa}=. $gdsaDB || echo "${gdsa}=0" >> $gdsaDB
    else
      echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t${gdsa}\t Validation FAILURE!"
      cat /tmp/.SA_error.log.tmp >> /tmp/SA_error.log
      ((gdsaFail++))
    fi
  done

  [[ -n $gdsaFail ]] \
    && echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t$gdsaFail Failure(s). See /tmp/SA_error.log"

}
[[ $@ =~ --skip ]] || init_DB

############################################################################
# Least Usage Load Balancing of GDSA Accounts
############################################################################

# needs work.
# break the fileLock for stale files
touch $fileLock
#staleFiles=$(find $localDir -mindepth 2 -amin +${staleFileTime} -type d)
staleFiles=$(find $localDir -mindepth 2 -type d)
while read -r line; do
  grep "${line}" $fileLock && \
  cat $fileLock | egrep -v ^${line}$ > ${fileLock}.tmp && \
  mv ${fileLock}.tmp ${fileLock} && \
  echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\tBreaking fileLock on $line"
done <<<$staleFiles

cleanUp(){
  echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tSIGINT: Clearing filelocks and logs. Exiting."
  rm ${jsonPath}/log/* &>/dev/null
  echo -n '' > /tmp/fileLock
  exit 0
}
trap "cleanUp" SIGINT
trap "cleanUp" SIGTERM


echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tStarting File Monitor.\tMax Concurrent Uploads: $maxConcurrentUploads"
while true; do
# purge empty folders
find $localDir -mindepth 2 -type d -empty -delete

#find $localDir -mindepth 2 -mmin +${modTime} -type d -links 2 -prune \
#  -exec du -s {} \; | sort -gr | awk -F'\t' '{print $1":"$2 }' > /tmp/uploadQueueBuffer

# black magic: find list of all dirs that have files at least 2 minutes old
# and only print the deepest directories, then sort them by largest first, then sanitize input
sc=$(awk -F"/" '{print NF-1}' <<<${localDir})
for dir in $(find ${localDir} -mindepth $sc -links 2 -prune -type d); do
 test $(find $dir -type f -mmin -${modTime} -print -quit) || du -s $dir
done | sort -gr |  awk -F'\t' '{print $1":"$2 }' > /tmp/uploadQueueBuffer

# iterate through uploadQueueBuffer and update gdsaDB, incrementing usage values
  while read -r line; do

    gdsaLeast=$(sort -gr -k2 -t'=' ${gdsaDB} | egrep ^GDSA[0-9]+=. | tail -1 | cut -f1 -d'=')
    if [[ -z $gdsaLeast ]]; then
      echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tFailed To get gdsaLeast. Exiting."
      exit 1
    fi

    # skip on files currently being uploaded,
    # or if more than # of rclone uploads exceeds $maxConcurrentUploads
    numCurrentTransfers=$(grep -c "$localDir" $fileLock)
    file=$(awk -F':' '{print $2}' <<< ${line})
    if [[ ! $(cat $fileLock | egrep ^"${file}"$ ) && $numCurrentTransfers -le $maxConcurrentUploads && -n $line ]]; then
      flag=1
      fileSize=$(awk -F':' '{print $1}' <<< ${line})
      [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\tSupertransfer rclone_upload input: "${file}""
      rclone_upload $gdsaLeast "${file}" $remoteDir &
      sleep 0.5

    fi
  done </tmp/uploadQueueBuffer
  [[ -n $dbug && flag == 1 ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\tNo Files Found in ${localDir}. Sleeping." && flag=0
  sleep 5
done


echo "script end"
