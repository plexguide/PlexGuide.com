#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
 ## point to variable file for ipv4 and domain.com

file="/var/plexguide/pgdupes.autodelete"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "ON" > /var/plexguide/pgdupes.autodelete
    echo "true" > /var/plexguide/pgdupes.autodelete2.json
    exit
fi

stat=$( cat /var/plexguide/pgdupes.autodelete )

HEIGHT=14
WIDTH=48
CHOICE_HEIGHT=7
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDupes"
MENU="Make a Selection:"

OPTIONS=(A "Deploy PGDupes"
         B "PlexToken"
         C "Config Plex Library"
         D "AutoDelete - Currently: $stat"
         E "Current Library Config"
         F "Mini FAQ & Info"
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
            file="/opt/appdata/plexguide/plextoken"
            if [ -e "$file" ]
            then
                echo "" 1>/dev/null 2>&1
            else
                dialog --title "--- WARNING ---" --msgbox "\nYou need to create a PLEXToken!\n\nYou must have not read the Wiki!" 0 0
                bash /opt/plexguide/menus/pgdupes/main.sh
                exit
            fi

            file="/var/plexguide/plex.library.json"
            if [ -e "$file" ]
            then
                echo "" 1>/dev/null 2>&1
            else
                dialog --title "--- WARNING ---" --msgbox "\nYou need to create your Library layout for us!\n\nYou must have not read the Wiki!" 0 0
                bash /opt/plexguide/menus/pgdupes/main.sh
                exit
            fi

            dialog --infobox "Deploying PGDupes!" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pgdupes 1>/dev/null 2>&1
            #read -n 1 -s -r -p "Press any key to continue"
            dialog --title "PGDupes Status" --msgbox "\nPGDupes Deployment Complete! Use the CMD pgdupes in the Command Line!" 0 0
            bash /opt/plexguide/menus/pgdupes/main.sh
            exit
            ;;
        B)
            bash /opt/plexguide/scripts/plextoken/main.sh
            ;;
        C)
            bash /opt/plexguide/menus/pgdupes/paths.sh
            ;;
        D)
            bash /opt/plexguide/menus/pgdupes/onoff.sh
            bash /opt/plexguide/menus/pgdupes/main.sh
            exit
            ;;
        E)
            display="$(cat /var/plexguide/plex.library)"
            dialog --title "Your Stated Plex Library" --msgbox "\n$display" 0 0
            bash /opt/plexguide/menus/pgdupes/main.sh
            exit
            ;;
        F)
            dialog --title "Modify Config File" --msgbox "\nTo Modify the rest of the configurations, type the following: sudo nano /opt/appdata/pgdupes/config.json\n\nPlease visit pgdupes.plexguide.com for way more info!" 0 0
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/pgdupes/main.sh
