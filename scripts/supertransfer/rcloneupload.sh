#!/bin/bash
#                      |---uploadQueueBuffer--|
#usage: rclone_upload  <dirsize> <upload_dir>  <rclone> <remote_root_dir>
rclone_upload() {
  local localFile="${2}"
  local sanitizedLocalFile=$(sed 's/(/\\(/g; s/)/\\)/g; s/\[/\\[/g; s/\]/\\]/g; s/\^/\\^/g; s/\*/\\*/g; s/"/\\"/g; s/!/\\!/g' <<<$localFile)
  # exit if file is locked
  [[ $(egrep -x "${sanitizedLocalFile}" $fileLock) ]] && return 1
  # lock file so multiple uploads don't happen
  echo "${localFile}" >> $fileLock
  local fileSize="${1}"
  local gdsa="${3}"
  local remoteDir="${4}"
  # set vars
  local rclone_fin_flag=0
  local driveChunkSize
  rclone_fin_flag=0
  local t1=$(date +%s)
  source settings.conf

  # load latest usage value from db
  local oldUsage=$(egrep -m1 ^$gdsa=. $gdsaDB | awk -F'=' '{print $2}')
  local Usage=$(( oldUsage + fileSize ))
  [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\t$gdsa\tUsage: $Usage"
  # update gdsaUsage file with latest usage value
  sed -i '/'^$gdsa'=/ s/=.*/='$Usage'/' $gdsaDB
  echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\t$gdsaLeast\tStarting Upload: ${localFile}"

	# memory optimization
  local freeRam=$(free | grep Mem | awk '{print $4/1000000}')
	case $freeRam in
		[0123456789][0123456789][0123456789]*) driveChunkSize="1024M" ;;
		[0123456789][0123456789]*) driveChunkSize="1024M" ;;
	  [6789]*) driveChunkSize="512M" ;;
		5*) driveChunkSize="256M" ;;
		4*) driveChunkSize="128M" ;;
		3*) driveChunkSize="64M" ;;
		2*) driveChunkSize="32M" ;;
	  *) driveChunkSize="8M" ;;
	esac
  #echo "[DBUG] rcloneupload: localFile=${localFile}"
  #echo "[DBUG] rcloneupload: raw input 2=$2"

  local tmp=$(echo "${2}" | rev | cut -f1 -d'/' | rev | sed 's/ /_/g; s/\"//g')
  local logfile=${logDir}/${gdsa}_${tmp}.log
	rclone move --tpslimit 6 --checkers=16 \
		--log-file=${logfile}  \
		--log-level INFO --stats 5s \
		--exclude="**partial~" --exclude="**_HIDDEN~" \
		--exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
		--drive-chunk-size=$driveChunkSize \
		"${localFile}" "$gdsa:${remote_dir}${localFile#"$localDir"}" && rclone_fin_flag=1

  # check if rclone finished sucessfully
  local secs=$(( $(date +%s) - $t1 ))
  if [[ $rclone_fin_flag == 1 ]]; then
    printf "[$(date +%m/%d\ %H:%M)] [ OK ]\t$gdsaLeast\tFinished Upload: "${localFile}" in %dh:%dm:%ds\n" $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)) \
    | tee /tmp/superTransferUploadSuccess
  else
    printf "[$(date +%m/%d\ %H:%M)] [FAIL]\t$gdsaLeast\tUPLOAD FAILED: "${localFile}" in %dh:%dm:%ds\n" $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)) \
    | tee /tmp/superTransferUploadFail
    cat $logfile >> /tmp/rclonefail.log
    [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\t$gdsa\tREVERTED Usage: $Usage"
    # revert gdsaDB back to old value if upload failed
    sed -i '/'^$gdsa'=/ s/=.*/='$oldUsage'/' $gdsaDB
  fi
  # release fileLock when file transfer finishes (or fails)
  cat $fileLock | grep -xv "${sanitizedLocalFile}" > /tmp/fileLock.tmp && mv /tmp/fileLock.tmp /tmp/fileLock
  [[ -e $logfile ]] && rm $logfile
	}
