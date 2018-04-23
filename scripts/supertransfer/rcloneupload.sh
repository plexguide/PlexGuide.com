#!/bin/bash


# usage: rclone_upload <Service Account> <local_dir/filename> <remote_dir>
rclone_upload() {

  # set vars
  local rclone_fin_flag ; local gdsa ; local localDir
  local time_start ; local remoteDir; local drive_chunk_size
  rclone_fin_flag=0
  t1=$(date +%s)
  gdsa=${1}; localDir=${2}; remoteDir=${3}
  source settings.conf
	touch ${logDir}/${gdsa}.log

  # lock file so multiple uploads don't happen
  echo ${2} >> $filelock
  # debug
  echo -e "[$(date +%m/%d\ %H:%M)] [INFO]\t$gdsaLeast\tStarting Upload: $file"


	# memory optimization
  freeRam=$(free | grep Mem | awk '{print $4/1000000}')
	case $freeRam in
		[0123456789][0123456789][0123456789]*) drive_chunk_size="512" ;;
		[0123456789][0123456789]*) drive_chunk_size="512M" ;;
	  [6789]*) drive_chunk_size="512M" ;;
		5*) drive_chunk_size="256M" ;;
		4*) drive_chunk_size="128M" ;;
		3*) drive_chunk_size="64M" ;;
		2*) drive_chunk_size="32M" ;;
	  *) drive_chunk_size="8M" ;;
	esac

  echo "debug: rclone_upload gdsa=$gdsa localdirfile="${2}" remoteDir=$remoteDir " && rclone_fin_flag=1

	# rclone move --tpslimit 6 --checkers=16 \
	# 	--log-file=${logDir}/${gdsa}.log  \
	# 	--log-level INFO --stats 5s \
	# 	--exclude="**partial~" --exclude="**_HIDDEN~" \
	# 	--exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
	# 	--drive-chunk-size=$drive_chunk_size \
  #   --drive-impersonate $gdsaImpersonate
	# 	"${2}" $gdsa:$remote_dir && rclone_fin_flag=1

  # check if rclone finished sucessfully
  secs=$(( $(date +%s) - $t1 ))
  if [[ $rclone_fin_flag == 1 ]]; then
    printf "[$(date +%m/%d\ %H:%M)] [ OK ]\t$gdsaLeast\t Finished Upload: $file in %dh:%dm:%ds\n" $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
  else
    printf "[$(date +%m/%d\ %H:%M)] [FAIL]\t$gdsaLeast\t UPLOAD FAILED: $file in %dh:%dm:%ds\n" $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
  fi
  # release filelock when file transfer finishes (or fails)
  cat $filelock | egrep -v ^\"${2}\"$ > /tmp/filelock.tmp && mv /tmp/filelock.tmp /tmp/filelock
	}
