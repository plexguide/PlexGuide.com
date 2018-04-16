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


var_init(){
	declare -a varlist=("CPU_PERC" "MEM_PERC" "MEM_FREE" "IO_PERC" "local_disk_perc" \
			    "local_disk_current" "move_perc" "maxdisk" "nzbget_hr" \
			    "nzbget_perc" "sabnzbd_hr" "sabnzbd_perc" "deluge_hr" \
			    "deluge_perc" "rutorrent_hr" "rutorrent_perc" "netspeed_kbits"\
			    "network_status" "system_status" "disk_status" "transfer_queue_status" \
			    "queued_files_left" "active_transfers" "queued_transfers" \
			    "queued_files_left_PP" "filelist" "filelist_PP" "filelist_buffer_PP" \
			    "filelist_buffer" "filelist_buffer2" "filelist_buffer2_PP" "filelist_buffer3" \
			    "post_processing_queue_status" "network_status" "system_status" "disk_status" \
			    "transfer_queue_status" "gdrive_size" "filelist_buffer_junk" "filelist_buffer_tmp"\
			    "rclone_spinner" \
			    )
	for file in ${varlist[@]}; do
		echo -n '' > /tmp/$file
	done
	echo $(date +%s) > /tmp/var_init
}

# USAGE: system_status_init <interval_sec>
system_status(){
while true; do
	echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')] > /tmp/CPU_PERC
	free | grep Mem | awk '{print $3/$2 * 100}' | cut -f1 -d'.' > /tmp/MEM_PERC
	free --giga | grep Mem | awk '{print $3}' > /tmp/MEM_FREE
	sar | awk '{print $6}' | tail -1 | cut -f1 -d'.' > /tmp/IO_PERC
	echo $(date +%s) > /tmp/system_status
done &
}

#################################
#################################

# USAGE: disk_space_init <interval_sec>
disk_status(){
move_dir='/mnt/move'
nzbget_dir='/mnt/nzbget'
sabnzbd_dir='/mnt/sabnzbd'
deluge_dir='/mnt/deluge'
rutorrent_dir='/mnt/rutorrent'
while true; do
	disk=$(cat /etc/fstab | grep -m1 " / " | cut -f5 -d' ')
	maxdisk_bytes=$(df | grep $disk | awk '{print $2}')
	echo $(df -BG | grep $disk | awk '{print $2}') > /tmp/maxdisk
	echo $(df | grep $disk | awk '{print $5}' | sed 's/%//') > /tmp/local_disk_perc
	echo $(df -BG | grep $disk | awk '{print $3}' | sed 's/G//') > /tmp/local_disk_current


	move_size=$(du $move_dir | tail -1 | awk '{print $1}')
	echo $(python3 -c "print(int($move_size/$maxdisk_bytes*100))") > /tmp/move_perc
	echo $(du -h $move_dir | tail -1 | awk '{print $1}') > /tmp/move_hr

	# gdrive size
	du -h /mnt/plexdrive | tail -1 | awk '{print $1}' > /tmp/gdrive_size

		# nzbget size calc
		if [[ $(grep nzbget /tmp/applist) ]]; then
			nzbget_size=$(du $nzbget_dir | tail -1 | awk '{print $1}')
			python3 -c "print(int($nzbget_size/$maxdisk_bytes*100))" > /tmp/nzbget_perc
			du -h $nzbget_dir | tail -1 | awk '{print $1}' > /tmp/nzbget_hr
		fi

		# sabnzbd size calc
		if [[ $(grep sabnzbd /tmp/applist) ]]; then
			sabnzbd_size=$(du $sabnzbd_dir | tail -1 | awk '{print $1}')
			python3 -c "print(int($sabnzbd_size/$maxdisk_bytes*100))" > /tmp/sabnzbd_perc
			du -h $sabnzbd_dir | tail -1 | awk '{print $1}' > /tmp/sabnzbd_hr
		fi

		# deluge size calc
		if [[ $(grep deluge /tmp/applist) ]]; then
			deluge_size=$(du $deluge_dir | tail -1 | awk '{print $1}')
			python3 -c "print(int($deluge_size/$maxdisk_bytes*100))" > /tmp/deluge_perc
			du -h $deluge_dir | tail -1 | awk '{print $1}' > /tmp/deluge_hr
		fi

		# rutorrent size calc
		if [[ $(grep rutorrent /tmp/applist) ]]; then
			rutorrent_size=$(du $rutorrent_dir | tail -1 | awk '{print $1}')
			python3 -c "print(int($rutorrent_size/$maxdisk_bytes*100))" > /tmp/rutorrent_perc
			du -h $rutorrent_dir | tail -1 | awk '{print $1}' > /tmp/rutorrent_hr
		fi

		echo $(date +%s) > /tmp/disk_status
		[[ $1 == '' ]] && interval=30 || interval=$1
		sleep $interval
	done &
	}

#################################
#################################

# USAGE:
# get_speed <interface> <interval>
# returns <rx_speed> <tx_speed> in /tmp/netspeed_mbits
# returns <rx_speed> <tx_speed> in /tmp/netspeed_kbits
network_status(){
interface=$(route | grep default | awk '{print $8}')
interval=1
while true; do
		Rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
		Tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes)
		sleep $interval
		Rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
		Tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes)
		TxPPS=$(( $Tx2 - $Tx1 ))
		RxPPS=$(( $Rx2 - $Rx1 ))
		TxMbps=`expr $TxPPS / 125000 / $interval`
		RxMbps=`expr $RxPPS / 125000 / $interval`
		echo "$RxMbps $TxMbps" > /tmp/netspeed_mbits

		TxKbps=`expr $TxPPS / 125 / $interval`
		RxKbps=`expr $RxPPS / 125 / $interval`
		echo "$RxKbps $TxKbps" > /tmp/netspeed_kbits

		#return formatted speed
		echo -n "" > /tmp/netspeed
		if [[ $RxMbps == 0 ]]; then
			echo -en "\e[0m${RxKbps} kb/s\e[0m " >> /tmp/netspeed
		elif [[ $RxMbps -lt 100 ]]; then
			echo -en "\e[34m${RxMbps} Mb/s\e[0m " >> /tmp/netspeed
		elif [[ $RxMbps -lt 400 ]]; then
			echo -en "\e[32m${RxMbps} Mb/s\e[0m " >> /tmp/netspeed
		elif [[ $RxMbps -lt 800 ]]; then
			echo -en "\e[30;42m${RxMbps} Mb/s\e[0m " >> /tmp/netspeed
		else
			echo -en "\e[41;29m${RxMbps} Mb/s\e[0m " >> /tmp/netspeed
		fi

		if [[ $TxMbps == 0 ]]; then
			echo -en "\e[0m${TxKbps} kb/s\e[0m" >> /tmp/netspeed
		elif [[ $TxMbps -lt 100 ]]; then
			echo -en "\e[34m${TxMbps} Mb/s\e[0m" >> /tmp/netspeed
		elif [[ $TxMbps -lt 400 ]]; then
			echo -en "\e[32m${TxMbps} Mb/s\e[0m" >> /tmp/netspeed
		elif [[ $TxMbps -lt 800 ]]; then
			echo -en "\e[30;42m${TxMbps} Mb/s\e[0m" >> /tmp/netspeed
		else
			echo -en "\e[41;29m${TxMbps} Mb/s\e[0m" >> /tmp/netspeed
		fi
	echo $(date +%s) > /tmp/network_status
done &
}

#################################
#################################

transfer_queue_status(){
declare -a dirlist=("/mnt/move/movies" "/mnt/move/tv")
while true; do
term_width=$(( $(cat /tmp/superstatus_cols) / 3 - 5))
term_height=$(( $(cat /tmp/superstatus_lines) - 7))
for dir in ${dirlist[@]}; do
	slashcount=$(awk -F"/" '{print NF-1}' <<< ${dir})
	find $dir -size +50M -type f | cut -f$(( $slashcount + 3)) -d'/' | grep -v '*' >> /tmp/filelist_buffer
done
# get currently transfering
rclone_log=/opt/appdata/plexguide/rclone
touch $rclone_log
tac $rclone_log | grep -m1 Transferring -B20 | grep '*' | cut -f2 -d'*' \
		| cut -f1 -d':' | sed 's/\...//' \
		> /tmp/rclone

# transfer progress bar calc
tac $rclone_log | grep -m1 Transferring -B20 | grep '*' \
		| cut -f2 -d':' | cut -f1 -d'%'\
		> /tmp/rclone_tmp
if [[ $(cat /tmp/rclone_tmp) != '' ]]; then
	awk '{ sum += $1 } END { print sum }' /tmp/rclone_tmp > /tmp/rclone_current
	echo $(( $(wc -l /tmp/rclone_tmp | awk '{print $1}') * 100)) > /tmp/rclone_max
else
	echo 100 > /tmp/rclone_current
	echo 100 > /tmp/rclone_max
fi

# scale to term width & length
while read line; do
	# print line in green if currently transferrring according to rclone logs
	if [[ $(egrep -si "$(echo $line | rev | cut -c1-10 | rev)" /tmp/rclone 2>/dev/null) ]]; then
		echo -en "\e[92m$line" | cut -c1-$term_width >> /tmp/filelist_buffer2
		echo -en "\e[1m" >> /tmp/filelist >> /tmp/filelist_buffer2
	# print blinking line if file currently moving
	elif [[ $(lsof | grep "/mnt/move/" | grep "$line") ]]; then
		echo -en "\e[5m$line" | cut -c1-$term_width >> /tmp/filelist_buffer3
		echo -en "\e[1m" >> /tmp/filelist >> /tmp/filelist_buffer3
	else
		echo $line | cut -c1-$term_width  >> /tmp/filelist_buffer3
	fi
done < /tmp/filelist_buffer
# generate active transfer list
cat /tmp/filelist_buffer2 | tail -n$term_height > /tmp/active_transfers
# generate queued transfer list
term_height2=$(( $(wc -l /tmp/active_transfers | awk '{print $1}') - $term_height ))
if [[ $term_height2 > 0 ]]; then
	cat /tmp/filelist_buffer3 | tail -n$term_height2 > /tmp/queued_transfers
else
	echo -n '' > /tmp/queued_transfers
fi
# tell user how many more files are queued that weren't able to be shown
if [[ $(wc -l /tmp/filelist_buffer3 | awk '{print $1}') > $(wc -l /tmp/queued_transfers | awk '{print $1}') ]]; then
	filesleft=$(( $(wc -l /tmp/filelist_buffer3 | awk '{print $1}') - $(wc -l /tmp/queued_transfers | awk '{print $1}') ))
	echo "...$filesleft More File(s)..." > /tmp/queued_files_left
else
	echo -n '' > /tmp/queued_files_left
fi

# reset buffers
echo -n '' > /tmp/filelist_buffer3
echo -n '' > /tmp/filelist_buffer2
echo -n '' > /tmp/filelist_buffer
echo $(date +%s) > /tmp/transfer_queue_status
sleep 1
done &
}


post_processing_queue_status(){

# dynamically generate PP queue dirs to search
declare -a dirlist=()
[[ $(cat /tmp/applist | grep -i nzbget) ]] && \
	dirlist+=("/mnt/nzbget/completed/movies" "/mnt/nzbget/completed/tv")
[[ $(cat /tmp/applist | grep -i sabnzbd) ]] && \
	dirlist+=("/mnt/sab/completed/movies" "/mnt/sab/completed/tv")
[[ $(cat /tmp/applist | grep -i deluge) ]] && \
	dirlist+=("/mnt/deluge/downloaded")
[[ $(cat /tmp/applist | grep -i rutorrent) ]] && \
	dirlist+=("/mnt/rutorrent/completed")

while true; do
term_width=$(( $(cat /tmp/superstatus_cols) / 3 - 5))
term_height=$(( $(cat /tmp/superstatus_lines) - 15))
for dir in ${dirlist[@]}; do
	slashcount=$(awk -F"/" '{print NF-1}' <<< ${dir})
	find $dir -type f | cut -f$(( $slashcount + 3)) -d'/' | grep -v '*' | sed '/^\s*$/d' >> /tmp/filelist_buffer_tmp

	# calc junk file size
	find $dir -type f \( -iname "*.iso" -o -iname "*.nfo" \
		-o -iname "*sample*" -o -iname "*unpack*" -o -iname "*proof*"\
	        -o -iname "*.sup" \) \
		-print0 | du --files0-from=- -c | tail -n1 | awk '{print $1}' \
		>> /tmp/filelist_buffer_calc_tmp
done
# sum junk file size
junksum=$(awk '{sum += $1} END {print sum}' /tmp/filelist_buffer_calc_tmp)
echo "$(python3 -c "print(round($junksum/1000000, 2))")GB" > /tmp/filelist_buffer_calc
# filter out junk files
cat /tmp/filelist_buffer_tmp | egrep -iv "sample|nfo|iso|unpack|proof|sup" > /tmp/filelist_buffer_PP
cat /tmp/filelist_buffer_tmp | egrep -i "sample|nfo|iso|unpack|proof|sup" | wc -l | awk '{print $1}' > /tmp/filelist_buffer_junk
echo -n '' > /tmp/filelist_buffer_tmp
echo -n '' > /tmp/filelist_buffer_calc_tmp
# scale to term width & length

while read line; do
	# print blinking line if file currently open
	if [[ $(lsof | egrep -i \
		"/mnt/nzbget/completed|/mnt/sab/completed|/mnt/deluge/downloaded|/mnt/rutorrent/completed" \
		| grep "$line") ]]; then

		echo -en "\e[5m$line" | cut -c1-$term_width >> /tmp/filelist_buffer2_PP
		echo -en "\e[1m" >> /tmp/filelist_PP >> /tmp/filelist_buffer2_PP
	else
		echo $line | cut -c1-$term_width  >> /tmp/filelist_buffer2_PP
	fi
done < /tmp/filelist_buffer_PP

# generate post processing list
cat /tmp/filelist_buffer2_PP | tail -n$term_height > /tmp/PP_queue

# tell user how many more files are queued that weren't able to be shown
if [[ $(wc -l /tmp/filelist_buffer2_PP | awk '{print $1}') > $term_height ]]; then
	filesleft=$(( $(wc -l /tmp/filelist_buffer2_PP | awk '{print $1}') - $term_height ))
	echo "...$filesleft More File(s)..." > /tmp/queued_files_left_PP
else
	echo -n '' > /tmp/queued_files_left_PP
fi

# reset buffers
echo -n '' > /tmp/filelist_buffer2_PP
echo -n '' > /tmp/filelist_buffer_PP
echo $(date +%s) > /tmp/post_processing_queue_status
sleep 1
done &
}
