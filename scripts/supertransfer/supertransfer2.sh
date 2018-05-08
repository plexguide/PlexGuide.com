############################################################################
# INIT
############################################################################
echo -e " [INFO] Initializing Supertransfer2 Load Balanced Multi-SA Uploader..."
source /opt/plexguide/scripts/supertransfer/rcloneupload.sh
source /opt/plexguide/scripts/supertransfer/init.sh
source /opt/plexguide/scripts/supertransfer/settings.conf
source ${userSettings}
#dbug=on


# check to make sure filepaths are there
touch /tmp/superTransferUploadSuccess &>/dev/null
touch /tmp/superTransferUploadFail &>/dev/null
[[ -e $gdsaDB ]] || touch $gdsaDB &>/dev/null
[[ -e $uploadHistory ]] || touch $uploadHistory &>/dev/null
[[ -d $jsonPath ]] || mkdir $jsonPath &>/dev/null
[[ -d $logDir ]] || mkdir $logDir &>/dev/null
[[ ! -e $userSettings ]] && echo -e " [FAIL] No User settings found in $userSettings. Exiting." && exit 1


clean_up(){
  echo -e " [INFO] SIGINT: Clearing filelocks and logs. Exiting."
  numSuccess=$(cat /tmp/superTransferUploadSuccess | wc -l)
  numFail=$(cat /tmp/superTransferUploadFail | wc -l)
  totalUploaded=$(awk -F'=' '{ sum += $2 } END { print sum / 1000000 }' $gdsaDB)
  sizeLeft=$(du -hc ${localDir} | tail -1 | awk '{print $1}')
  echo -e " [STAT]\t$numSuccess Successes, $numFail Failures, $sizeLeft left in $localDir, ${totalUploaded}GB total uploaded"
  rm ${logDir}/* &>/dev/null
  echo -n '' > ${fileLock}
  rm /tmp/superTransferUploadFail &>/dev/null
  rm /tmp/superTransferUploadSuccess &>/dev/null
  rm /tmp/.SA_error.log.tmp &>/dev/null
  rm /tmp/SA_error.log &>/dev/null
  exit 0
}
trap "clean_up" SIGINT
trap "clean_up" SIGTERM

############################################################################
# Initalize gdsaDB (can be skipped with --skip)
############################################################################
init_DB(){

  # get list of avail gdsa accounts
  gdsaList=$(rclone listremotes --config /root/.config/rclone/rclone.conf | sed 's/://' | egrep '^GDSA[0-9]+$')
  if [[ -n $gdsaList ]]; then
      numGdsa=$(echo $gdsaList | wc -w)
      echo -e " [INFO] Initializing $numGdsa Service Accounts."
  else
      echo "[INFO] No GDSA's found in /root/.config/rclone/rclone.conf, checking ~/.config/rclone/rclone.conf for GDSA's"
      # backup root's rclone conf
      [[ -e /root/.config/rclone/rclone.conf ]] && cp /root/.config/rclone/rclone.conf /root/.config/rclone/rclone.conf.back
      # cp home's rclone conf to root
      [[ -e ~/.config/rclone/rclone.conf ]] && cp ~/.config/rclone/rclone.conf /root/.config/rclone/rclone.conf
      gdsaList=$(rclone listremotes --config /root/.config/rclone/rclone.conf | sed 's/://' | egrep '^GDSA[0-9]+$')
      [[ -z $gdsaList ]] && echo -e " [FAIL] No Valid SA accounts found! Is Rclone Configured With GDSA## remotes?" && exit 1
      echo "[INFO] Found GDSA's in ~/ and copying to /root"
      numGdsa=$(echo $gdsaList | wc -w)
      echo -e " [INFO] Initializing $numGdsa Service Accounts."
  fi

  # reset existing logs & db
  echo -n '' > /tmp/SA_error.log
  validate(){
      local s=0
      rclone lsd --config /root/.config/rclone/rclone.conf ${1}:/ &>/tmp/.SA_error.log.tmp && s=1
      if [[ $s == 1 ]]; then
        echo -e " [ OK ] ${1}\t Validation Successful!"
        egrep -q ^${1}=. $gdsaDB || echo "${1}=0" >> $gdsaDB
      else
        echo -e " [WARN] ${1}\t Validation FAILURE!"
        cat /tmp/.SA_error.log.tmp >> /tmp/SA_error.log
        ((gdsaFail++))
      fi
  }
i=0
numProcs=10
  # parallelize validator for speeeeeed
    for gdsa in $gdsaList; do
      if (( i++ >= numProcs )); then
        wait -n
      fi
      validate $gdsa &
      sleep 0.1
    done
  wait
  gdsaLeast=$(sort -gr -k2 -t'=' ${gdsaDB} | egrep ^GDSA[0-9]+=. | tail -1 | cut -f1 -d'=')
  [[ -n $gdsaFail ]] && echo -e " [WARN] $gdsaFail Failure(s). See /tmp/SA_error.log"

}

[[ $@ =~ --skip ]] || init_DB

############################################################################
# Least Usage Load Balancing of GDSA Accounts
############################################################################


numGdsa=$(cat $gdsaDB | wc -l)
maxDailyUpload=$(python3 -c "print(round($numGdsa * 750 / 1000, 3))")
echo -e " [INFO] START\tMax Concurrent Uploads: $maxConcurrentUploads, ${maxDailyUpload}TB Max Daily Upload"
echo -n '' > ${fileLock}

while true; do
  # purge empty folders
  find "${localDir}" -mindepth 2 -type d -empty -delete
  # remote duplicates from fileLock
  awk -i inplace '!seen[$0]++' ${fileLock}
  # black magic: find list of all dirs that have files at least 1 minutes old that aren't hidden
  # and put the deepest directories in an array, then sort by dirsize
  sc=$(awk -F"/" '{print NF-2}' <<<${localDir})
  unset a i
      while IFS= read -r -u3 -d $'\0' dir; do
          [[ $(find "${dir}" -type f -mmin -${modTime} -print -quit) == '' && ! $(find "${dir}" -name "*.partial~") ]] \
              && a[i++]=$(du -s "${dir}")
      done 3< <(find ${localDir} -mindepth $sc -type d -not -path '*/\.*' -links 2 -not -empty -prune -print0)

      # sort by largest files first
      IFS=$'\n' uploadQueueBuffer=($(sort -gr <<<"${a[*]}"))
      unset IFS

      # iterate through each folder and upload
      for i in $(seq 0 $((${#uploadQueueBuffer[@]}-1))); do
        flag=0
        # pause if max concurrent uploads limit is hit
        numCurrentTransfers=$(grep -c "$localDir" $fileLock)
        [[ $numCurrentTransfers -ge $maxConcurrentUploads ]] && break

        # get least used gdsa account
        gdsaLeast=$(sort -gr -k2 -t'=' ${gdsaDB} | egrep ^GDSA[0-9]+=. | tail -1 | cut -f1 -d'=')
        [[ -z $gdsaLeast ]] && echo -e " [FAIL] Failed To get gdsaLeast. Exiting." && exit 1

        # upload folder (rclone_upload function will skip on filelocked folders)
        if [[ -n "${uploadQueueBuffer[i]}" ]]; then
          [[ -n $dbug ]] && echo -e " [DBUG] Supertransfer rclone_upload input: "${file}""
          IFS=$'\t'
          #             |---uploadQueueBuffer--|
          #input format: <dirsize> <upload_dir>  <rclone> <remote_root_dir>
          rclone_upload ${uploadQueueBuffer[i]} $gdsaLeast $remoteDir &
          unset IFS
          sleep 0.2
        fi
      done
      unset -v uploadQueueBuffer[@]
      sleep $sleepTime
done
