############################################################################
# INIT
############################################################################
source rcloneupload.sh
source init.sh
source settings.conf
source /opt/appdata/plexguide/supertransfer/usersettings.conf
dbug=on

init_DB(){
  [[ $gdsaImpersonate == 'your@email.com' ]] \
    && echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tNo Email Configured. Please edit $usersettings" \
    && exit 1

  # get list of avail gdsa accounts
  gdsaList=$(rclone listremotes | sed 's/://' | egrep '^GDSA[0-9]+$')
  if [[ -n $gdsaList ]]; then
      numGdsa=$(echo $gdsaList | wc -w)
      maxDailyUpload=$(python3 -c "print(round($numGdsa * 750 / 1000, 3))")
      echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tInitializing $numGdsa Service Accounts:\t${maxDailyUpload}TB Max Daily Upload"
      echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tValidating Domain Wide Impersonation:\t$gdsaImpersonate"
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
    rclone touch --drive-impersonate $gdsaImpersonate ${gdsa}:/.test &>/tmp/.SA_error.log.tmp && s=1
    if [[ $s == 1 ]]; then
      echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\tGDSA Impersonation Success:\t ${gdsa}"
      grep -q "${gdsa}" $gdsaDB || echo "${gdsa}=0" >> $gdsaDB
    else
      echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\tGDSA Impersonation Failure:\t ${gdsa}"
      cat /tmp/.SA_error.log.tmp >> /tmp/SA_error.log
      ((gdsaFail++))
    fi
  done

  [[ -n $gdsaFail ]] \
    && echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\t$gdsaFail Failure(s)."

}
init_DB

############################################################################
# Least Usage Load Balancing of GDSA Accounts
############################################################################

# break the filelock for stale files
touch $filelock
staleFiles=$(find $localDir -mindepth 2 -amin +${staleFileTime} -type f)
while read -r line; do
  grep "${line}" $filelock && \
  cat $filelock | egrep -v ^${2}$ > /tmp/filelock.tmp && \
  mv /tmp/filelock.tmp /tmp/filelock
  echo -e "[$(date +%m/%d\ %H:%M)] [WARN]\tBreaking filelock on $line"
done <<<$staleFiles


while true; do
# iterate through uploadQueueBuffer and update gdsaDB, incrementing usage values
uploadQueueBuffer=$(find $localDir -mindepth 2 -mmin +${modTime} -type f \
  -exec du -s {} \; | awk -F'\t' '{print $1 ":" "\"" $2 "\""}' | sort -gr)

  while read -r line; do

    gdsaLeast=$(sort -gr -k2 -t'=' ${gdsaDB} | egrep ^GDSA[0-9]+=. | tail -1 | cut -f1 -d'=')
    if [[ -z $gdsaLeast ]]; then
      echo -e "[$(date +%m/%d\ %H:%M)] [FAIL]\tFailed To get gdsaLeast. Exiting."
      exit 1
    fi

    # skip on files currently being uploaded,
    # or if more than # of rclone uploads exceeds $maxConcurrentUploads
    numCurrentTransfers=$(grep -c "$localdir" $filelock)
    file=$(awk -F':' '{print $2}' <<< "${line}")
    if [[ ! $(cat $filelock | egrep ^${file}$ ) && $numCurrentTransfers -le $maxConcurrentUploads ]]; then
      fileSize=$(awk -F':' '{print $1}' <<< $line)
      rclone_upload $gdsaLeast "${file}" $remoteDir &
      sleep 0.5
      # add timestamp & log
      # load latest usage value from db
      oldUsage=$(grep $gdsaLeast $gdsaDB | awk -F'=' '{print $2}')
      Usage=$(( oldUsage + fileSize ))
      [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\t$gdsaLeast\tUsage: $Usage"
      # update gdsaUsage file with latest usage value
      sed -i '/'^$gdsaLeast'=/ s/=.*/='$Usage'/' $gdsaDB
      source $gdsaDB
    fi
  done <<< "$uploadQueueBuffer"

  sleep 60
  # clean empty folders
  find $localdir -mindepth 2 -type d -empty -delete
done


echo "script end"
