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

HEIGHT=10
WIDTH=32
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Version Install"
MENU="Make a Selection"

OPTIONS=(A "Developer: Latest"
         B "Stable   : 5.048"
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
            mv /opt/plexguide/scripts/docker-no/upgrade2.sh /tmp
            cd /tmp
            bash /tmp/upgrade2.sh
            version="Developer"
            dialog --title "PG Application Status" --msgbox "\nUpgrade Complete - Version $version!" 0 0
            exit 0 ;;
        B)
            version="5.048" ;;
        Z)
            clear
            exit 0
            ;;
esac

rm -r /opt/plexg* 2>/dev/nu*
wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/$version.zip -P /tmp
unzip /tmp/$version.zip -d /opt/
mv /opt/PlexG* /opt/plexguide
bash /opt/plexg*/sc*/ins*
rm -r /tmp/$version.zip
git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /tmp/pg
rm -r /opt/plexguide/menus/version/main.sh
mv /tmp/pg/menus/version/main.sh /opt/plexguide/menus/version/
rm -r /tmp/pg/
read -n 1 -s -r -p "Press any key to continue "
clear