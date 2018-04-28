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

### Pull the API Keys
file="/opt/appdata/radarr/config.xml"
if [ -e "$file" ]
then
info=$( cat /opt/appdata/radarr/config.xml ) 
info=${info#*<ApiKey>} 1>/dev/null 2>&1
info1=$( echo ${info:0:32} ) 1>/dev/null 2>&1
echo "$info1" > /var/plexguide/api.radarr
fi

file="/opt/appdata/sonarr/config.xml"
if [ -e "$file" ]
then
    info=$( cat /opt/appdata/sonarr/config.xml ) 
    info=${info#*<ApiKey>} 1>/dev/null 2>&1
    info2=$( echo ${info:0:32} ) 1>/dev/null 2>&1
    echo "$info2" > /var/plexguide/api.sonarr
fi

### If Both are Blank, which means neither deployed, warn USER!
if [ "$info2" == "$info1" ]
then
   dialog --title "-- WARNING! --" --msgbox "\nYou must deploy at least RADARR or SONARR. If you plan to do both, deploy both before starting!\n\nThis script automatically retrieves your API Keys for both programs! " 0 0
   exit
fi

file="/var/plexguide/api.trakkey"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    dialog --title "-- WARNING! --" --msgbox "\nYou must set a Track.TV API Key!\n\nVisit pgtrak.plexguide.com for more info?" 0 0
    
    if dialog --stdout --title "Are You Ready?" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --yesno "\nDo you have your Trekt API key?" 0 0; then
        bash /opt/plexguide/menus/pgtrak/traktkey.sh
    else
        dialog --title "-- Note! --" --msgbox "\nCome Back Anytime! As most non-US citizen say -- Cheers! --" 0 0
    exit
    fi
fi

############################# BLANK OUT
file="/var/plexguide/pgtrak.sonarr"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "/NOT-set" > /var/plexguide/pgtrak.sonarr
    exit
fi

file="/var/plexguide/pgtrak.radarr"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "/NOT-set" > /var/plexguide/pgtrak.radarr
fi

radarr=$( cat /var/plexguide/pgtrak.radarr )
sonarr=$( cat /var/plexguide/pgtrak.sonarr )

############################# START
HEIGHT=13
WIDTH=48
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGTrak"
MENU="Make a Selection:"

OPTIONS=(A "Deploy PGTrak"
         B "Trakt API-Key"
         C "Change Path - Sonarr: $sonarr:"
         D "Change Path - Radarr: $radarr"
         E "View APIs and Paths"
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
            dialog --infobox "Deploying PGTrak!" 3 26
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pgtrak 1>/dev/null 2>&1
            #read -n 1 -s -r -p "Press any key to continue"
            dialog --title "PGDupes Status" --msgbox "\nPGDupes Deployment Complete! Use the CMD pgdupes in the Command Line!" 0 0
            bash /opt/plexguide/menus/pgdupes/main.sh
            exit
            ;;
        B)
            dialog --infobox "Recorded API Key: $key" 0 0
            if dialog --stdout --title "API Question?" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --yesno "\nAPI Correct? $key" 0 0; then
                rm -r /var/plexguide/api.trakkey
            else
                bash /opt/plexguide/menus/pgtrak/traktkey.sh
                exit
            fi
            dialog --infobox "Entered API Key: $key" 0 0
            bash /opt/plexguide/menus/pgtrak/traktkey.sh
            ;;
        C)
            bash /opt/plexguide/menus/pgtrak/sonarrpath.sh
            ;; 
        D)
            bash /opt/plexguide/menus/pgtrak/radarrpath.sh
            ;;
        E)
            display="$(cat /var/plexguide/plex.library)"
            dialog --title "Your Stated Plex Library" --msgbox "\n$display" 0 0
            bash /opt/plexguide/menus/pgdupes/main.sh
            exit
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac
bash /opt/plexguide/menus/pgtrak/main.sh