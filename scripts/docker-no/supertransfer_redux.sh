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

# init
cat /opt/appdata/plexguide/current_index | grep [0-9] || echo 0 > /opt/appdata/plexguide/current_index
cat /opt/appdata/plexguide/current_gdrive | grep gdrive || echo gdrive > /opt/appdata/plexguide/current_gdrive
touch /opt/appdata/plexguide/rclone
chmod 755 /opt/appdata/plexguide/rclone

# get gdrive transfer type
if [[ $(rclone listremotes | grep -c gcrypt) > 1 ]];
 transfer_type='multi_crypt'
	echo -e "Multiple Encrypted Gdrives Detected. This feature is not supported yet; exiting."
	exit 1; fi
elif [[ $(rclone listremotes | grep -c gcrypt) == 1 ]];
 transfer_type='single_crypt'
	echo -e "Encrypted Gdrive Detected. This feature is not supported yet; exiting."
	exit 1; fi
elif [[ $(rclone listremotes | grep -c gdrive) > 1 ]];
 transfer_type='multi'
elif [[ $(rclone listremotes | grep -c gdrive) == 1 ]];
 transfer_type='single'
else
	echo -e "No Valid Gdrive Found, have you configured rclone?:\n$(rclone listremotes)\n EXITING!"
	exit 1; fi

detect_throttle() {
	# calc egress speed to google servers in Mb/s
	upspeed=$(2>/dev/null iftop -t -s $sample_size \
		| grep "1e100.net" -B1 \
		| grep '=>' \
		| grep Mb \
		| awk '{print $4}' \
		| sed 's/Mb//' \
		| awk '{SUM += $1} END {print SUM}') # add all upload speeds together
	[[ $upspeed == '' ]] && $upspeed=1
	upspeed=$(python -c "print(int($upspeed+0))") # float & null val sanity check
	echo "$upspeed" > /opt/appdata/plexguide/current_speed

	case $(tail -n 20 /opt/appdata/plexguide/rclone | grep -m1 "Transferring:" -A20 | grep "\*" | wc -l) in
		1) threshold=$(( 20 + $threshold_modifier )) ;;
		2) threshold=$(( 30 + $threshold_modifier )) ;;
	  *) threshold=$(( 40 + $threshold_modifier )) ;;
	esac

		current_transfers=$(tail -n 20 /opt/appdata/plexguide/rclone | grep -m1 "Transferring:" -A20 | grep "\*" | wc -l)
		if [[ upspeed -gt $threshold || $current_transfers -eq 0 ]]; then
			echo no
		else
			echo yes
		fi

	}

# usage: rclone_sync <gdrive>
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

	rclone move --tpslimit 6 --checkers=16 \
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
						elif [[ $transfer_type == 'multi' || $transfer_type == 'multi_crypt' ]]; then
							pkill rclone
							echo
							echo
							echo "Switching Gdrives to: $(cat /opt/appdata/plexguide/current_gdrive)"
							echo "$(date +%H:%M:%S) $(cat /opt/appdata/plexguide/current_gdrive) THROTTLING CONFIRMED: $(cat /opt/appdata/plexguide/current_speed)Mbit/s with $false_positive_checks Confirmations." >> /opt/appdata/plexguide/supertransfer.log
							gdrive_switch
						elif [[ $transfer_type == 'single' || $transfer_type == 'crypt' ]]; then
							current_gdrive_var=$(cat /opt/appdata/plexguide/current_gdrive)
							echo $(date +%s) > /opt/appdata/plexguide/${current_gdrive_var}_cooldown
							echo "24 hour cooldown period started at $(date)"
						else
							echo "Error: Invalid Transfer Type on Throttle dection daemon"
						fi
				fi
		else
			sleep $false_positive_wait
		fi
	done &
fi

# Gdrive Uploader

# MULTI UPLOAD
if [[ $transfer_type == 'multi' || $transfer_type == 'single' ]]; then
	while true; do
		if [[ $(queued_transfers) -gt 0 ]]; then
			current_gdrive_var=$(cat /opt/appdata/plexguide/current_gdrive)
			[[ -e /opt/appdata/plexguide/${current_gdrive_var}_cooldown ]] || echo '1' > /opt/appdata/plexguide/${current_gdrive_var}_cooldown
			cooldown=$(( $(date +%s) - $(cat /opt/appdata/plexguide/${current_gdrive_var}_cooldown) ))
			if [[ $cooldown > 86400 ]]; then
				rclone_sync $(cat /opt/appdata/plexguide/current_gdrive)
				echo "Currently Selected Gdrive: $(cat /opt/appdata/plexguide/current_index) ($(cat /opt/appdata/plexguide/current_gdrive))"
				echo "Starting Upload to $(cat /opt/appdata/plexguide/current_gdrive). Transfer Queue: $(queued_transfers) as of $(date +%H:%M)"
				echo "Starting Upload to $(cat /opt/appdata/plexguide/current_gdrive). Transfer Queue: $(queued_transfers) $(date +%H:%M:%S)" >> /opt/appdata/plexguide/supertransfer.log
			else
				cooldown_left=$(eval "echo $(date -ud "@$cooldown" +'%H hours %M minutes')")
				echo "$current_gdrive_var cooldown: $cooldown_left"
				echo $cooldown_left > /tmp/${current_gdrive_var}_cooldown_left
				[[ $transfer_type == 'multi' ]] && gdrive_switch
		else
			echo "Waiting Until Transfer Queue is at Least 100M"
		fi
		sleep 60
	done
elif [[ $transfer_type == 'crypt' || $transfer_type == 'multi_crypt' ]]; then
		echo "crypt not yet implemented"
else
	echo "error: gdrive uploader failed"
fi
