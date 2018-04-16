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

source /opt/plexguide/scripts/docker-no/superstatus/simple_curses.sh
source /opt/plexguide/scripts/docker-no/superstatus/rnjesus.sh
source /opt/plexguide/scripts/docker-no/superstatus/system_status.sh
echo
echo
cat /opt/plexguide/scripts/docker-no/superstatus/ART.txt
echo
echo "        Please Report Any Bugs Via Discord"
echo "          Suggestions Are Also Welcome"
echo -e "               \e[032mThanks For Testing.\e[0m "
# check for requirements
declare -a dep=("vmstat" "route" "tput" "docker" "free" "sar" "python3")
for prog in ${dep[@]}; do
	which $prog &>/dev/null || echo "ERROR: Missing Dependency: $prog"
	which $prog &>/dev/null || exit 1
done
# test for running apps
docker ps | awk '{print $NF}' | grep -v NAMES > /tmp/applist
# init vars
echo $(tput cols) > /tmp/superstatus_cols
echo $(tput lines) > /tmp/superstatus_lines
progress=0
maxprogress=20
interface=$(route | grep default | awk '{print $8}')
declare -a initstat=( "var_init" "network_status" "system_status" "disk_status"  "transfer_queue_status" "post_processing_queue_status")
#wait until they load
for init in ${initstat[@]}; do
	$init
	y=0
	i=1
	sp="/-\|"
	while [[ (( y < 9 )) || $(date +%s) -gt $(( $(cat /tmp/$init) + 4 ))  ]]; do
	((y++))
	echo -en "[${sp:i++%${#sp}:1}]"
	echo -en "  Initializing: $init"
	for l in $(seq $(( $(echo $init | wc -c) + 18 )) ); do
		echo -en "\b"
	done
	sleep 0.1
	done
	echo -en "\n"
done
echo "[!] Initializing: curses_library"

move_dir='/mnt/move'
nzbget_dir='/mnt/nzbget'
sabnzbd_dir='/mnt/sab'
deluge_dir='/mnt/deluge'
rutorrent_dir='/mnt/rutorrent'



main(){
	# get terminal size
	echo $(tput cols) > /tmp/superstatus_cols
	echo $(tput lines) > /tmp/superstatus_lines


	# active transfer status
	window "Active Transfers" "green" "33%"
	if [[ ! -e /opt/appdata/plexguide/rclone ]]; then
		append "ERROR: rclone log not found"
		append "You may have to reinstall rclone to get the new patch"
	elif [[ $(cat /tmp/active_transfers) != '' ]]; then
		term_width=$(( $(cat /tmp/superstatus_cols) / 3 - 7))
		progressbar $term_width $(cat /tmp/rclone_current) $(cat /tmp/rclone_max) "green" "grey"
		append_file "/tmp/active_transfers"
	else
		append "-- rclone Inactive --"
	fi

	if [[ $(cat /tmp/queued_transfers) != '' ]]; then
		addsep
		append "Queued Transfers"
		append_file "/tmp/queued_transfers"
	fi

	if [[ $(cat /tmp/queued_files_left) != '' ]]; then
		append "$(cat /tmp/queued_files_left)"
	fi

	endwin

	col_right
	move_up

	# gdrive transfer status window

	window "Gdrive Storage" "green" "33%"
		append_tabbed "Gdrive Size : $gdrive_size" 2
		append_tabbed "Est. UL Today : WIP" 2
		append_tabbed "Upload Speed: $(awk '{print $3,$4}' /tmp/netspeed)" 2
		append_tabbed "Download Speed: $(awk '{print $1,$2}' /tmp/netspeed)" 2
	endwin

	window "Post Processing" "red" "33%"
	if [[ $(cat /tmp/PP_queue) != '' ]]; then
		append_file "/tmp/PP_queue"
	else
		append "-- None --"
	fi

	if [[ $(cat /tmp/queued_files_left_PP) != '' ]]; then
		filesleft=$(cat /tmp/queued_files_left_PP)
		append "$filesleft"
	fi

	if [[ $(cat /tmp/filelist_buffer_junk) != 0 ]]; then
		addsep
		append "$(cat /tmp/filelist_buffer_junk) Junk Files @ $(cat /tmp/filelist_buffer_calc)"
	fi
	endwin

	col_right
	move_up

	# system status: cpu, mem, iowait, network
	window "System Status" "magenta" "33%"
		term_width_ss=$(( $(cat /tmp/superstatus_cols) / 3 - 16))
		vumeter " CPU $CPU_PERC%" "$term_width_ss" "$CPU_PERC" "100" "green" "red" "gray"
		vumeter " MEM ${MEM_FREE}GB" "$term_width_ss" "$MEM_PERC" "100" "green" "red" "gray"
		vumeter " IOWAIT $IO_PERC%" "$term_width_ss" "$IO_PERC" "50" "green" "red" "gray"
		blinkenlights " NETWORK" "green" "red" "grey" "black" ${blinkylights[@]}
	endwin

	# disk space window
	window "Disk Space" "magenta" "33%"
		term_width_ds=$(( $(cat /tmp/superstatus_cols) / 3 - 20))
		# total disk size calc
		vumeter " $LOCAL_DISK_CURRENT/$maxdisk Local" "$term_width_ds" "$LOCAL_PERC" "100" "green" "red" "gray"
		# /mnt/move size calc
		vumeter " $move_hr Move" "$term_width_ds" "$move_perc" "100" "green" "red" "gray"

		# nzbget size calc
		[[ $(grep nzbget /tmp/applist) ]] && \
			vumeter " $nzbget_hr NZBget" "$term_width_ds" "$nzbget_perc" "100" "green" "red" "gray"

		# sabnzbd size calc
		[[ $(grep sabnzbd /tmp/applist) ]] && \
			vumeter " $sabnzbd_hr SABNZBD" "$term_width_ds" "$nzbget_perc" "100" "green" "red" "gray"

		# deluge size calc
		[[ $(grep deluge /tmp/applist) ]] && \
			vumeter " $deluge_hr Deluge" "$term_width_ds" "$deluge_perc" "100" "green" "red" "gray"

		# rutorrent size calc
		[[ $(grep rutorrent /tmp/applist) ]] && \
			vumeter " $deluge_hr Deluge" "$term_width_ds" "$rutorrent_perc" "100" "green" "red" "gray"

	endwin

	# active notifications (only shows if active)
	window "Active Notifications" "green" "33%"
		append "Work In Progress..."
	endwin


}

update(){
	up_speed=$(awk '{print $2}' /tmp/netspeed_kbits)
	down_speed=$(awk '{print $1}' /tmp/netspeed_kbits)
	term_width_b_gen=$(( $(cat /tmp/superstatus_cols) / 3 - 18))
	b_gen $term_width_b_gen 200000 $up_speed $down_speed
	# system status
	CPU_PERC=$(cat /tmp/CPU_PERC)
	MEM_PERC=$(cat /tmp/MEM_PERC)
	MEM_FREE=$(cat /tmp/MEM_FREE)
	IO_PERC=$(cat /tmp/IO_PERC)
	# disk space
	LOCAL_PERC=$(cat /tmp/local_disk_perc)
	LOCAL_DISK_CURRENT=$(cat /tmp/local_disk_current)
	move_perc=$(cat /tmp/move_perc)
	move_hr=$(cat /tmp/move_hr)
	gdrive_size=$(cat /tmp/gdrive_size)
	maxdisk=$(cat /tmp/maxdisk)
	nzbget_hr=$(cat /tmp/nzbget_hr)
	nzbget_perc=$(cat /tmp/nzbget_perc)
	sabnzbd_hr=$(cat /tmp/sabnzbd_hr)
	sabnzbd_perc=$(cat /tmp/sabnzbd_perc)
	deluge_hr=$(cat /tmp/deluge_hr)
	deluge_perc=$(cat /tmp/deluge_perc)
	rutorrent_hr=$(cat /tmp/rutorrent_hr)
	rutorrent_perc=$(cat /tmp/rutorrent_perc)
	if [[ $(cat /tmp/rclone_current) != 100 && $(cat /tmp/netspeed_mbits | awk '{print $1}') != 0 ]]; then
		echo $(date +%s) > /tmp/rclone_spinner
	fi

	sleep 0.2

	return 0
}

main_loop update
