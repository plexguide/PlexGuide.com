#!/bin/bash


# usage: rclone_upload <Service Account> <local_dir/filename> <remote_dir>
rclone_upload() {

  # set vars
  local rclone_fin_flag ; local gdsa ; local localFile
  local time_start ; local remoteDir; local driveChunkSize
  local oldUsage; local Usage
  rclone_fin_flag=0
  t1=$(date +%s)
  gdsa=${1}
  # sanitize input of special chars and spaces by esacaping them
  localFile=$(sed 's/ /\\ /g; s/\"//g; s/(/\\(/g; s/)/\\)/g; s/\]/\\]/g; s/\[/\\[/g; s/|/\\|/g; s/\*/\\\*/g; s/&/\\&/g; s/\^/\\^/g; s/\;/\\;/g' <<<$var)
  remoteDir=${3}
  source settings.conf
  [[ ! -d $logDir ]] && mkdir $logDir

  # add timestamp & log
  # load latest usage value from db
  oldUsage=$(egrep -m1 ^$gdsa=. $gdsaDB | awk -F'=' '{print $2}')
  Usage=$(( oldUsage + fileSize ))
  [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\t$gdsa\tUsage: $Usage"
  # update gdsaUsage file with latest usage value
  sed -i '/'^$gdsa'=/ s/=.*/='$Usage'/' $gdsaDB

  # lock file so multiple uploads don't happen
  echo ${2} >> $fileLock
  # debug
  echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\t$gdsaLeast\tStarting Upload: ${localFile}"

	# memory optimization
  freeRam=$(free | grep Mem | awk '{print $4/1000000}')
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
  slashCut=$(awk -F"/" '{print NF-1+2}' <<< "${localDir}")
  remote_dir2=$(cut -f${slashCut} -d'/' <<< "${localFile}")

  tmp=$(echo $2 | rev | cut -f1 -d'/' | rev | sed 's/ /_/g; s/\"//g')
  logfile=${logDir}/${gdsa}_${tmp}.log
	rclone move --tpslimit 6 --checkers=16 \
		--log-file=${logfile}  \
		--log-level INFO --stats 5s \
		--exclude="**partial~" --exclude="**_HIDDEN~" \
		--exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
    --delete-empty-src-dirs \
		--drive-chunk-size=$driveChunkSize \
		${localFile} $gdsa:${remote_dir}/${remote_dir2}/${localFile} && rclone_fin_flag=1

  # check if rclone finished sucessfully
  secs=$(( $(date +%s) - $t1 ))
  if [[ $rclone_fin_flag == 1 ]]; then
    printf "[$(date +%m/%d\ %H:%M)] [ OK ]\t$gdsaLeast\tFinished Upload: $file in %dh:%dm:%ds\n" $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
  else
    printf "[$(date +%m/%d\ %H:%M)] [FAIL]\t$gdsaLeast\tUPLOAD FAILED: $file in %dh:%dm:%ds\n" $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
    cat $logfile >> /tmp/rclonefail.log
    [[ -n $dbug ]] && echo -e "[$(date +%m/%d\ %H:%M)] [DBUG]\t$gdsa\tREVERTED Usage: $Usage"
    # revert gdsaDB back to old value if upload failed
    sed -i '/'^$gdsa'=/ s/=.*/='$oldUsage'/' $gdsaDB
  fi
  # release fileLock when file transfer finishes (or fails)
  cat $fileLock | egrep -v ^${2}$ > /tmp/fileLock.tmp && mv /tmp/fileLock.tmp /tmp/fileLock
  rm $logfile &>/dev/null
	}
