#!/bin/bash

# usage: rclone_upload <Service Account> <local_dir/filename> <remote_dir>
rclone_upload() {
  gdsa=$1
  localDir=$2
  remoteDir=$3
	# memory_optimization
  freeRam=$()
	case $freeRam in
		1) drive_chunk_size="1024M" ;;
		2) drive_chunk_size="512M" ;;
		3) drive_chunk_size="256M" ;;
		4) drive_chunk_size="128M" ;;
		5) drive_chunk_size="64M" ;;
		6) drive_chunk_size="32M" ;;
	  *) drive_chunk_size="16M" ;;
	esac

	rclone move --tpslimit 6 --checkers=16 \
		--log-file=/opt/appdata/plexguide/rclone \
		--log-level INFO --stats 5s \
		--exclude="**partial~" --exclude="**_HIDDEN~" \
		--exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
 		--transfers $transfers \
		--drive-upload-cutoff=$drive_upload_cutoff \
		--drive-chunk-size=$drive_chunk_size \
		--max-size=$max_size \
		$local_dir $gdsa:$remote_dir
	}
