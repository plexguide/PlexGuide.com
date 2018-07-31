#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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
echo 'INFO - @Tools Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

domain=$( cat /var/plexguide/server.domain )

HEIGHT=12
WIDTH=30
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Tools"

OPTIONS=(A "CloudCMD"
         B "NetData"
         C "pyLoad"
         D "SpeedTEST Server"
         E "x2go"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            dialog --title "--- NOTE ---" --msgbox "\nThe default username and password is:\n\nUser: plex\nPass: guide\n\nIf you forget, please visit the Wiki!" 0 0
            echo 'INFO - Selected: NETData' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudcmd --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        B)
            echo 'INFO - Selected: NETData' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags netdata --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"

            ;;
        C)
            echo 'INFO - Selected: PYLoad' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags pyload --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"

            ;;
        D)
            echo 'INFO - Selected: SpeedTest Server' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags speedtest --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        E)
            echo 'INFO - Selected: X2Go' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags x2go
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        Z)
            exit 0 ;;
    esac

#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/tools.sh
