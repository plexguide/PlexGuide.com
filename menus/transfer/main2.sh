#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq - FlickerRate
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


export NCURSES_NO_UTF8_ACS=1
clear

################# Unencrypted Rclone Question
clear
#rclone listremotes | grep crypt && whiptail --title "Warning" --msgbox "This is for the UNENCRYPTED RCLONE only. Please remove all encrypted rclone remotes." 8 56 && exit 0

while [ 1 ]
do
CHOICE=$(
whiptail --title "Transfer Performance" --menu "Make your choice" 12 38 5 \
    "1)" "Use MULTI-DRIVE SPEED TRANSFER"  \
    "2)" "BACK TO NORMAL TRANSFER"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    echo
    echo "Please Add Another GDrive. (Name It Whatever You'd Like.)"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    rclone config
	if [[ $(rclone listremotes | grep -v crypt | wc -l) -ge 2 ]]; then
    		systemctl stop move
    		systemctl disable move
    		systemctl stop transfer
    		systemctl disable transfer
    		systemctl stop time
    		systemctl disable time
    		systemctl daemon-reload
	    	ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer
    		echo ""
    		echo "Load Balancing Between $(rclone listremotes | grep -v crypt | wc -l) GDrives."
    		echo "MAXIMUM DAILY TRANSFER $(( $(rclone listremotes | grep -v crypt | wc -l) * 750 ))GB."
    		read -n 1 -s -r -p "Press any key to continue "
	else
		echo
		echo "No New GDrives Were Added."
		echo
    		read -n 1 -s -r -p "Press any key to continue "
	fi
    ;;

    "2)")
    clear
    systemctl daemon-reload
    systemctl enable move
    systemctl start move
    systemctl stop transfer
    systemctl stop time
    systemctl disable transfer
    systemctl disable time
    systemctl daemon-reload
    echo ""
    echo "Back to normal"
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "4)")
      clear
      exit 0
      ;;
esac
done
exit
