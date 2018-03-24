#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flicker-Rate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

which rclone &>/dev/null || exit 1
which iftop &>/dev/null || exit 1

# BACKLOG DETECTION SETTINGS
backlog_restart=off
backlog_threshold=4   # will restart rclone if this many items are waiting for transfer.

# GDRIVE THROTTLE DETECTION SETTINGS
threshold_modifier=0	# adjust throttle detection threshold (+/- num) in Mb/s
sample_size=60		#in seconds
false_positive_checks=5	# of times to double-check throttling
false_positive_wait=10

# RCLONE TRANSFER SETTINGS
transfers=16
max_size=99G
bw_limit=1000M 		# adjust this speed if rclone is interfering with plex playback
drive_upload_cutoff=1G
local_dir='/mnt/move'
remote_dir='/'		# set custom gdrive mapping (default: '/')

# stop program if dependencies not met
#which iftop | grep iftop &>/dev/null || echo Supertransfer: Please Install iftop before running && exit 1
#which rclone | grep rclone &>/dev/null || echo Supertransfer: Please Install rclone before running && exit 1

# init
cat /opt/appdata/plexguide/current_index | grep [0-9] || echo 0 > /opt/appdata/plexguide/current_index
cat /opt/appdata/plexguide/current_gdrive | grep gdrive || echo gdrive > /opt/appdata/plexguide/current_gdrive
touch /opt/appdata/plexguide/rclone
chmod 755 /opt/appdata/plexguide/rclone



detect_throttle() {
	# calc egress speed to google servers in Mb/s
	upspeed=$(2>/dev/null iftop -t -s $sample_size \
		| grep "1e100.net" -B1 \
		| grep '=>' \
		| grep Mb \
		| awk '{print $4}' \
		| sed 's/Mb//' \
		| awk '{SUM += $1} END {print SUM}') # add all upload speeds together
	upspeed=$(python -c "print(int($upspeed+0))") # float & null val sanity check
	echo "$upspeed" > /opt/appdata/plexguide/current_speed

	case $(tail -n 20 /opt/appdata/plexguide/rclone | grep -m1 "Transferring:" -A20 | grep "\*" | wc -l) in
		1) threshold=$(( 20 + $threshold_modifier )) ;;
		2) threshold=$(( 30 + $threshold_modifier )) ;;
	  *) threshold=$(( 40 + $threshold_modifier )) ;;
	esac

		current_transfers=$(tail -n 20 /opt/appdata/plexguide/rclone | grep -m1 "Transferring:" -A20 | grep "\*" | wc -l)
		if [[ upspeed -gt $threshold || ( current_transfers -eq 0 ) ]]; then
			echo no
		else
			echo yes
		fi

	}

rclone_sync() {
	# memory_optimization
		queued_transfers=$(find /mnt/move ! -name "*.partial*" -type f -size +100M | wc -l)
		current_transfers=$(tail -n 20 /opt/appdata/plexguide/rclone | grep -m1 "Transferring:" -A20 | grep "\*" | wc -l)
	case $(find /mnt/move ! -name "*.partial*" -type f -size +100M | wc -l) in
		1) drive_chunk_size="1024M" ;;
		2) drive_chunk_size="512M" ;;
		3) drive_chunk_size="256M" ;;
		4) drive_chunk_size="128M" ;;
		5) drive_chunk_size="64M" ;;
		6) drive_chunk_size="32M" ;;
	        *) drive_chunk_size="16M" ;;
	esac

	rclone move --tpslimit 6 --no-traverse --checkers=16 \
		--log-file=/opt/appdata/plexguide/rclone \
		--log-level INFO --stats 5s \
		--exclude="**partial~" --exclude="**_HIDDEN~" \
		--exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
 		--transfers $transfers \
		--drive-upload-cutoff=$drive_upload_cutoff \
		--drive-chunk-size=$drive_chunk_size \
		--max-size=$max_size \
		$local_dir $1:$remote_dir # function input = gdrive remote name
	}

gdrive_switch() {
	current_index=$(cat /opt/appdata/plexguide/current_index)
	gdrive_index=( $(rclone listremotes | sed 's/://' | grep -v crypt) )
	if [[ current_index -ge $(( ${#gdrive_index[@]} - 1 )) ]]; then
		echo 0 > /opt/appdata/plexguide/current_index
		current_index=$(cat /opt/appdata/plexguide/current_index)
		echo ${gdrive_index[$current_index]} > /opt/appdata/plexguide/current_gdrive
	else
		echo $(( ++current_index )) > /opt/appdata/plexguide/current_index
		current_index=$(cat /opt/appdata/plexguide/current_index)
		echo ${gdrive_index[$current_index]} > /opt/appdata/plexguide/current_gdrive
	fi
	echo "Switching Gdrives: $current_index $(date)" >> /opt/appdata/plexguide/supertransfer.log
	}

queued_transfers () {
		echo $(find /mnt/move ! -name "*.partial*" -type f -size +100M | wc -l)
}

current_transfers() {
		echo $(tail -n 20 /opt/appdata/plexguide/rclone | grep -m1 "Transferring:" -A20 | grep "\*" | wc -l)
}

# Throttle Detection Daemon
while true; do
	if [[ $(detect_throttle) == "yes" ]]; then
		echo "Potential Throttle Detected at $(cat /opt/appdata/plexguide/current_speed)Mbit/s"
		for i in $(seq $false_positive_checks); do
			sleep $false_positive_wait
			if [[ "$(detect_throttle)" == "yes" ]]; then
				throttle_conf=$i
				echo "Throttle Confirmation ($i/$false_positive_checks) $(cat /opt/appdata/plexguide/current_speed)Mbit/s"
			else
				echo "Throttle Confirmation ($i/$false_positive_checks) False Positive! $(cat /opt/appdata/plexguide/current_speed)Mbit/s"
				break
			fi
		done
			if [[ throttle_conf -eq false_positive_checks ]]; then
				echo "THROTTLING CONFIRMED: $(cat /opt/appdata/plexguide/current_speed)Mbit/s with $false_positive_checks Confirmations."
					if [[ $(queued_transfers) -eq 1 ]]; then
						echo "Nothing In Backlog. Currently Trickle Uploading 1 Item."
						echo "Current Gdrive: $(cat /opt/appdata/plexguide/current_gdrive)"
						break
					else
						pkill rclone
						echo
						echo
						echo "Switching Gdrives to: $(cat /opt/appdata/plexguide/current_gdrive)"
						echo "$(date +%H:%M:%S) $(cat /opt/appdata/plexguide/current_gdrive) THROTTLING CONFIRMED: $(cat /opt/appdata/plexguide/current_speed)Mbit/s with $false_positive_checks Confirmations." >> /opt/appdata/plexguide/supertransfer.log
						gdrive_switch
					fi
			fi
	else
		sleep $false_positive_wait
	fi
done &

# Transfer Backlog Optimization
while true; do
	if [[ $(( $(queued_transfers) - $(current_transfers) )) -ge $backlog_threshold ]]; then
		if [[ $backlog_restart =~ "on" ]]; then
			pkill rclone
			echo
			echo
			echo "Currently Transfering: $(current_transfers) Backlog: $(( $(queued_transfers) - 1 ))"
			echo "Large Transfer Backlog Detected."
			echo "Restarting Rclone."
			echo "Restarting Rclone. $(date +%H:%M:%S)" >> /opt/appdata/plexguide/supertransfer.log
		fi
	fi
	sleep 60
done &

# Gdrive Uploader
while true; do
	if [[ $(queued_transfers) -gt 0 ]]; then
		echo "Currently Selected Gdrive: $(cat /opt/appdata/plexguide/current_index) ($(cat /opt/appdata/plexguide/current_gdrive))"
		echo "Starting Upload to $(cat /opt/appdata/plexguide/current_gdrive). Transfer Queue: $(queued_transfers) as of $(date +%H:%M)"
		echo "Starting Upload to $(cat /opt/appdata/plexguide/current_gdrive). Transfer Queue: $(queued_transfers) $(date +%H:%M:%S)" >> /opt/appdata/plexguide/supertransfer.log
		rclone_sync $(cat /opt/appdata/plexguide/current_gdrive)
		sleep 10
		echo "Cleaning Up $(find $local_dir -mindepth 2 -empty | wc -l) Empty Directories"
	 	find $local_dir -mindepth 2 -empty -delete
	else
		echo "Waiting Until Transfer Queue is at Least 100M"
	fi

done
