#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flickerate & Admin9705
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
HEIGHT=12
WIDTH=59
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Supertransfer by Flicker-Rate"
MENU="Make Your Selection Choice:"

OPTIONS=(A "Multi-Gdrive Supertransfer (depreciated)"
         B "Multi-SA Supertransfer2 req: teamdrives"
         C "BACK TO NORMAL TRANSFER"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
    A)
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
    B)
        clear
        bash /opt/plexguide/scripts/supertransfer/config.sh
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2
        journalctl -f -u supertransfer2
        ;;
    C)
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
    Z)
        clear
        exit 0
        ;;
    esac
clear

bash /opt/plexguide/menus/transfer/menu.sh
exit 0
