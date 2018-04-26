############################################################################
# INIT
############################################################################
source rcloneupload.sh
source init.sh
source settings.conf
source /opt/appdata/plexguide/supertransfer/usersettings.conf
#dbug=on

echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tInitializing Supertransfer2 Load Balanced Multi-SA Uploader..."

# check to make sure filepaths are there
touch /tmp/superTransferUploadSuccess
touch /tmp/superTransferUploadFail
[[ -e $gdsaDB ]] || touch $gdsaDB
[[ -e $uploadHistory ]] || touch $uploadHistory
[[ -d $jsonPath ]] || mkdir $jsonPath
[[ -d $logDir ]] || mkdir $logDir
[[ ! -e $userSettings ]] && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo User settings found in $userSettings. Exiting." && exit 1


clean_up(){
  echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tSIGINT: Clearing filelocks and logs. Exiting."
  numSuccess=$(cat /tmp/superTransferUploadSuccess | wc -l)
  numFail=$(cat /tmp/superTransferUploadFail | wc -l)
  totalUploaded=$(awk -F'=' '{ sum += $2 } END { print sum / 10000 }' $gdsaDB)
  sizeLeft=$(du -hc ${localDir} | tail -1 | awk '{print $1}')
  echo -e "[$(date +%m/%d\ %H:%M)] [STAT]\t$numSuccess Successes, $numFail Failures, $sizeLeft left in $localDir, ${totalUploaded}GB total uploaded"
  rm ${jsonPath}/log/* &>/dev/null
  echo -n '' > ${fileLock}
  rm /tmp/superTransferUploadFail &>/dev/null
  rm /tmp/superTransferUploadSuccess &>/dev/null
  rm /tmp/filelock.tmp &>/dev/null
  exit 0
}
trap "clean_up" SIGINT
trap "clean_up" SIGTERM

############################################################################
# Initalize gdsaDB (can be skipped with --skip)
############################################################################
init_DB(){

declare -a reqlist=(rclone awk sed egrep grep echo printf find sort tee)
for app in $reqlist; do
  [[ ! $(which $app) ]] && echo -e "$app dependency not met/nPlease install $app" && exit 1
done
  # get list of avail gdsa accounts
  gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
  if [[ -n $gdsaList ]]; then
      numGdsa=$(echo $gdsaList | wc -w)
      echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tInitializing $numGdsa Service Accounts."
  else
      echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Valid SA accounts found! Is Rclone Configured With GDSA## remotes?"
      exit 1
  fi

  # reset existing logs & db
  echo -n '' > /tmp/SA_error.log
  validate(){
      local s=0
      rclone touch ${1}:/SA_validate &>/tmp/.SA_error.log.tmp && s=1
      if [[ $s == 1 ]]; then
        echo -e "[$(date +%m/%d\ %H:%M)] [ OK ]\t${1}\t Validation Successful!"
        egrep -q ^${1}=. $gdsaDB || echo "${1}=0" >> $gdsaDB
      else
        echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t${1}\t Validation FAILURE!"
        cat /tmp/.SA_error.log.tmp >> /tmp/SA_error.log
        ((gdsaFail++))
      fi
  }
  # parallelize validator for speeeeeed
    for gdsa in $gdsaList; do
          validate $gdsa &
    done
  wait
  [[ -n $gdsaFail ]] && echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t$gdsaFail Failure(s). See /tmp/SA_error.log"
}
[[ $@ =~ --skip ]] || init_DB

############################################################################
# Least Usage Load Balancing of GDSA Accounts
############################################################################


numGdsa=$(cat $gdsaDB | wc -l)
maxDailyUpload=$(python3 -c "print(round($numGdsa * 750 / 1000, 3))")
echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tStarting File Monitor.\tMax Concurrent Uploads: $maxConcurrentUploads\t${maxDailyUpload}TB Max Daily Upload"
echo -n '' > ${fileLock}

while true; do
  # purge empty folders
  find "${localDir}" -mindepth 2 -type d -empty -delete
  # black magic: find list of all dirs that have files at least 1 minutes old
  # and put the deepest directories in an array, then sort by dirsize
  sc=$(awk -F"/" '{print NF-1}' <<<${localDir})
  unset a i
      while IFS= read -r -u3 -d $'\0' dir; do
          [[ $(find "${dir}" -type f -mmin -${modTime} -print -quit) == '' && ! $(find "${dir}" -type f -name "*.partial~") ]] \
              && a[i++]=$(du -s "${dir}")
      done 3< <(find ${localDir} -mindepth $sc -type d -links 2 -not -empty -prune -print0)

      # sort by largest files first
      IFS=$'\n' uploadQueueBuffer=($(sort -gr <<<"${a[*]}"))
      unset IFS

      # iterate through each folder and upload
      for i in $(seq 0 $((${#uploadQueueBuffer[@]}-1))); do
        # pause if max concurrent uploads limit is hit
        numCurrentTransfers=$(grep -c "$localDir" $fileLock)
        [[ $numCurrentTransfers -ge $maxConcurrentUploads ]] && break

        # get least used gdsa account
        gdsaLeast=$(sort -gr -k2 -t'=' ${gdsaDB} | egrep ^GDSA[0-9]+=. | tail -1 | cut -f1 -d'=')
        [[ -z $gdsaLeast ]] && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tFailed To get gdsaLeast. Exiting." && exit 1

        # upload folder (rclone_upload function will skip on filelocked folders)
        if [[ -n "${uploadQueueBuffer[i]}" ]]; then
          [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\tSupertransfer rclone_upload input: "${file}""
          IFS=$'\t'
          #             |---uploadQueueBuffer--|
          #input format: <dirsize> <upload_dir>  <rclone> <remote_root_dir>
          rclone_upload ${uploadQueueBuffer[i]} $gdsaLeast $remoteDir &
          unset IFS
          sleep 0.5
        fi
      done
      unset -v uploadQueueBuffer[@]
done
