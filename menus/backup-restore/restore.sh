#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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

HEIGHT=19
WIDTH=30
CHOICE_HEIGHT=12
#BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Restore Menu"
MENU="Choose a Program:"

OPTIONS=(1 "CouchPotato"
         2 "Deluge"
         3 "Emby"
         4 "Heimdall"
         5 "HTPCManager"
         6 "Jackett"
         7 "Lidarr"
         8 "MEDUSA"
         9 "Myler"
         10 "Muximux"
         11 "NZBGET"
         12 "NZBHydra"
         13 "NZBHydra2"
         14 "Ombi"
         15 "Organizr"
         16 "Plex"
         17 "Portainer"
         18 "Radarr"
         19 "Resilio"
         20 "Rutorrent"
         21 "SABNZBD"
         22 "Sonarr"
         23 "Tautulli"
         24 "Ubooquity"
         25 "Airsonic"
         Z "Exit")

CHOICE=$(dialog --clear \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "couchpotato" > /tmp/program_var ;;
        2)
            echo "deluge" > /tmp/program_var ;;
        3)
            echo "embyserver" > /tmp/program_var ;;
        4)
            echo "heimdall" > /tmp/program_var ;;
        5)
            echo "htpcmanager" > /tmp/program_var ;;
        6)
            echo "jackett" > /tmp/program_var ;;
        7)
            echo "lidarr" > /tmp/program_var ;;
        8)
            echo "medusa" > /tmp/program_var ;;
        9)
            echo "myler" > /tmp/program_var ;;
        10)
            echo "muximux" > /tmp/program_var ;;
        11)
            echo "nzbget" > /tmp/program_var ;;
        12)
            echo "nzbhydra" > /tmp/program_var ;;
        13)
            echo "nzbhydra2" > /tmp/program_var ;;
        14)
            echo "ombiv3" > /tmp/program_var ;;
        15)
            echo "organizr" > /tmp/program_var ;;
        16)
            echo "plex" > /tmp/program_var ;;
        17)
            echo "portainer" > /tmp/program_var ;;
        18)
            echo "radarr" > /tmp/program_var ;;
        19)
            echo "resilio" > /tmp/program_var ;;
        20)
            echo "rutorrent" > /tmp/program_var ;;
        21)
            echo "sabnzbd" > /tmp/program_var ;;
        22)
            echo "sonarr" > /tmp/program_var ;;
        23)
            echo "tautulli" > /tmp/program_var ;;
        24)
            echo "ubooquity" > /tmp/program_var ;;
        25)
            echo "airsonic" > /tmp/program_var ;;
        Z)
            clear
            exit 0 ;;

esac

app=$( cat /tmp/program_var )

file="/mnt/gdrive/plexguide/backup/$app.tar"
if [ -e "$file" ]
    then

        if dialog --stdout --title "Restore User Confirmation" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nDo you want to BACKOUT & EXIT from making the Restore -- $app -- ?" 0 0; then
            dialog --title "PG Restore Status" --msgbox "\nExiting! User selected to NOT Restore!" 0 0
            sudo bash /opt/plexguide/menus/backup-restore/restore.sh
            exit 0
        else
            clear
        fi
    else
        dialog --title "PG Restore Status" --msgbox "\nExiting! You have no GDrive data -- $app -- to Restore From GDrive!" 0 0
        sudo bash /opt/plexguide/menus/backup-restore/restore.sh
        exit 0
fi

    echo "true" > /tmp/alive
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags restore &>/dev/null &

    echo "$app: Restore Started" > /tmp/pushover
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

    loop="true"
    echo "true" > /tmp/alive
    while [ "$loop" = "true" ]
    do
        dialog --infobox "Restoring / " 3 16
        sleep 0.5
        dialog --infobox "Restoring | " 3 16
        sleep 0.5
        dialog --infobox "Restoring \ " 3 16
        sleep 0.5
        dialog --infobox "Restoring - " 3 16
        sleep 0.5
        loop=$(cat /tmp/alive) 1>/dev/null 2>&1
    done

echo "$app: Restore Complete" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

dialog --title "PG Backup Status" --msgbox "\nYour Restore of -- $app -- from Google Drive is Complete!" 0 0

sudo bash /opt/plexguide/menus/backup-restore/restore.sh
exit 0
