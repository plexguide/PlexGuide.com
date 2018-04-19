#!/bin/bash


# usage: rclone_upload <Service Account> <local_dir/filename> <remote_dir>
rclone_upload() {
  gdsa=$1; localDir=$2; remoteDir=$3

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

	rclone move --tpslimit 6 --checkers=16 \
		--log-file=/opt/appdata/plexguide/rclone \
		--log-level INFO --stats 5s \
		--exclude="**partial~" --exclude="**_HIDDEN~" \
		--exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
		--drive-upload-cutoff=$drive_upload_cutoff \
		--drive-chunk-size=$drive_chunk_size \
		$local_dir $gdsa:$remote_dir
	}
