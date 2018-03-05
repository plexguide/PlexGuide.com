#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Detique
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
HEIGHT=11
WIDTH=32
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Version Install"
MENU="Make a Selection"

OPTIONS=(A "Developer: 5.060"
         B "BETA 3   : 5.060"
         B "BETA 2   : 5.060"
         C "Stable   : 5.059"
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
            version="Developer"

            file="/var/plexguide/ask.yes"
            if [ -e "$file" ]
            then
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            if dialog --stdout --title "Version User Confirmation" \
               --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
               --yesno "\nDo You Want to EXIT and Backout from the Install: Version - $version" 7 50; then
               dialog --title "PG Update Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
            clear
            sudo bash /opt/plexguide/scripts/message/ending.sh
            exit 0
                else
            clear
            fi

            else
                clear
            fi
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            mv /opt/plexguide/scripts/docker-no/upgrade2.sh /tmp
            cd /tmp
            bash /tmp/upgrade2.sh
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1

            dialog --title "PG Application Status" --msgbox "\nUpgrade Complete - Version $version!" 0 0
            clear
            sudo bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
        B)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.060beta3" ;;
        C)  
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.060beta2" ''
        D)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.059" ;;
        Z)
            clear
            exit 0
            ;;
esac

file="/var/plexguide/ask.yes"
if [ -e "$file" ]
then

touch /var/plexguide/ask.yes 1>/dev/null 2>&1
if dialog --stdout --title "Version User Confirmation" \
   --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
   --yesno "\nDo You Want to EXIT and Backout from the Install: Version - $version" 7 50; then
   dialog --title "PG Update Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
clear
sudo bash /opt/plexguide/scripts/message/ending.sh
exit 0
    else
clear
fi


else
    clear
fi

rm -r /opt/plexg* 2>/dev/nu*
wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/$version.zip -P /tmp
unzip /tmp/$version.zip -d /opt/
mv /opt/PlexG* /opt/plexguide
bash /opt/plexg*/sc*/ins*
rm -r /tmp/$version.zip
touch /var/plexguide/ask.yes 1>/dev/null 2>&1

sudo bash /opt/plexguide/scripts/message/ending.sh
