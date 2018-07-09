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

file="/var/plexguide/pgtrak.secret"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    dialog --title "-- WARNING! --" --msgbox "\nYou must set a Track.TV Client & Secert!\n\nVisit pgtrak.plexguide.com for more info?" 0 0

    if dialog --stdout --title "Are You Ready?" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --yesno "\nDo you have your Trakt Keys?" 0 0; then
        bash /opt/plexguide/menus/pgtrak/traktkey.sh
    else
echo 'FAILURE - Required Trakt Keys' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

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
    echo "/unionfs/tv" > /var/plexguide/pgtrak.sonarr
fi

file="/var/plexguide/pgtrak.radarr"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "/unionfs/movies" > /var/plexguide/pgtrak.radarr
fi

radarr=$( cat /var/plexguide/pgtrak.radarr )
sonarr=$( cat /var/plexguide/pgtrak.sonarr )

# SET DEFAULT PROFILES
file="/var/plexguide/pgtrak.prosonarr"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "Any" > /var/plexguide/pgtrak.prosonarr
fi

file="/var/plexguide/pgtrak.proradarr"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "Any" > /var/plexguide/pgtrak.proradarr
fi

proradarr=$( cat /var/plexguide/pgtrak.proradarr )
prosonarr=$( cat /var/plexguide/pgtrak.prosonarr )

############################# START
echo 'INFO - @PGTrak Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=15
WIDTH=55
CHOICE_HEIGHT=8
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGTrak"
MENU="Make a Selection:"

OPTIONS=(A "Trakt API-Key"
         B "Sonarr Path: $sonarr"
         C "Radarr Path: $radarr"
         D "Profile Sonarr: $prosonarr"
         E "Profile Radarr: $proradarr"
         F "Deploy PGTrak"
         G "Mini FAQ & Info"
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
         dialog --title "Trakt Requested Information" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Trakt Client-ID:" 8 55 2>/var/plexguide/pgtrak.client
        key=$(cat /var/plexguide/pgtrak.client)
        dialog --infobox "Entered Client-ID: $key" 0 0

        if dialog --stdout --title "API Question?" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nClient Correct? $key" 0 0; then
            easteregg="foundme"
        else
            rm -r /var/plexguide/pgtrak.client
            bash /opt/plexguide/menus/pgtrak/traktkey.sh
            exit
        fi

        dialog --title "Trakt Requested Information" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Trakt Client-Secret:" 8 55 2>/var/plexguide/pgtrak.secret
        key=$(cat /var/plexguide/pgtrak.secret)
        dialog --infobox "Entered Client-ID: $key" 0 0

        if dialog --stdout --title "API Question?" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nSecret Correct? $key" 0 0; then
            easteregg="foundme"
        else
            rm -r /var/plexguide/pgtrak.client
            rm -r /var/plexguide/pgtrak.secret
            bash /opt/plexguide/menus/pgtrak/traktkey.sh
            exit
        fi
            dialog --title "Rerun PGTrak Note" --msgbox "\nIf done, rerun [Deploy PGTrak]. If not, your changes will not go into affect until you do so!" 0 0
            ;;
        B)
            bash /opt/plexguide/menus/pgtrak/sonarrpath.sh
            dialog --title "Rerun PGTrak Note" --msgbox "\nIf done, rerun [Deploy PGTrak]. If not, your changes will not go into affect until you do so!" 0 0
            ;;
        C)
            bash /opt/plexguide/menus/pgtrak/radarrpath.sh
            dialog --title "Rerun PGTrak Note" --msgbox "\nIf done, rerun [Deploy PGTrak]. If not, your changes will not go into affect until you do so!" 0 0
            ;;
        D)
             dialog --title "Set Your Sonarr Profile" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --inputbox "Sonarr Profile:" 8 40 2>/var/plexguide/pgtrak.prosonarr
            key=$(cat /var/plexguide/pgtrak.prosonarr)
            dialog --infobox "Entered Sonarr Profile: $key" 0 0

            if dialog --stdout --title "Profile Question?" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --yesno "\nProfile Correct? $key" 0 0; then
                easteregg="foundme"
            else
                rm -r /var/plexguide/pgtrak.prosonarr
                bash /opt/plexguide/menus/pgtrak/traktkey.sh
                exit
            fi
            ;;
        E)
             dialog --title "Set Your Radarr Profile" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --inputbox "Radarr Profile:" 8 40 2>/var/plexguide/pgtrak.proradarr
            key=$(cat /var/plexguide/pgtrak.proradarr)
            dialog --infobox "Entered Radarr Profile: $key" 0 0

            if dialog --stdout --title "Profile Question?" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --yesno "\nProfile Correct? $key" 0 0; then
                easteregg="foundme"
            else
                rm -r /var/plexguide/pgtrak.proradarr
                bash /opt/plexguide/menus/pgtrak/traktkey.sh
                exit
            fi
            ;;
        F)
            if dialog --stdout --title "-- Deploy Warning --" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --yesno "\nIf this IS NOT your first time, be aware that you may lose your personal configs from the config.json if you have edited it from before!\n\nEnsure that you set your Paths & your Quality!\n\nWant to Deploy PGTrak?" 0 0; then
                dialog --infobox "Deploying PGTrak!" 3 26
                sleep 2
                clear
                ansible-playbook /opt/plexguide/pg.yml --tags pgtrak
                read -n 1 -s -r -p "Press any key to continue"
                dialog --title "PGTrak Status" --msgbox "\nPGTrak Deployment Complete! Use the CMD pgtrak in the Command Line!" 0 0
            else
                dialog --title "-- WARNING! --" --msgbox "\nExiting! Nothing Happened!" 0 0
                exit
            fi
            ;;
        G)
            dialog --title "Modify Config File" --msgbox "\nTo Modify the rest of the configurations, type the following: sudo nano /opt/appdata/pgtrak/config.json\n\nPlease visit pgtrak.plexguide.com for way more info!" 0 0
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac
bash /opt/plexguide/menus/pgtrak/main.sh
