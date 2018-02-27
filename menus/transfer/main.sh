#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Detique
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

sudo touch /var/plexguide/asked.processor
################# Virtual Machine Check
if (whiptail --title "Virutal Machine Question" --yesno "Are You Utilizing the ENCRYPTED RCLONE?" 8 56) then

    whiptail --title "Virutal Machine - Yes" --msgbox "This is for the UNENCRYTPED RCLONE VERSION! If it works well, we will make an ENCRYPTED Version" 10 66
    exit
else
    whiptail --title "Virutal Machine - No" --msgbox "Ensure you that you have run the NORMAL UNENCRYPTED RCLONE INSTALL FIRST" 9 66
fi

while [ 1 ]
do
CHOICE=$(
whiptail --title "Processor Performance" --menu "Make your choice" 12 38 5 \
    "1)" "Use NEW SPEED TRANSFER"  \
    "2)" "BACK TO NORMAL TRANSFER"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    systemctl stop move
    systemctl disable move
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags transfer
    echo ""
    echo "Speeds are UNCAPPED - Thanks for TESTING"
    read -n 1 -s -r -p "Press any key to continue "
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

    "3)")
      clear
      exit 0
      ;;
esac
done
exit
