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
echo 'INFO - @Tools Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

domain=$( cat /var/plexguide/server.domain )

HEIGHT=11
WIDTH=30
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Tools"

OPTIONS=(A "CloudCMD"
         B "NetData"
         C "pyLoad"
         D "SpeedTEST Server"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            file="/opt/appdata/cloudcmd/.cloudcmd.json"
            if [ -e "$file" ]
                then
                    echo "" 1>/dev/null 2>&1
                else
                    dialog --title "--- NOTE ---" --msgbox "\nThe default username and password is:\n\nUser: plex\nPass: guide\n\nIf you forget, please visit the Wiki!" 0 0
            fi
            display=CloudCMD
            program=cmd
            port=7999
            dialog --infobox "Installing: $display" 3 30
            sleep 2
            clear
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags cloudcmd
            read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        B)
            display=NETDATA
            program=netdata
            port=19999
            dialog --infobox "Installing: $display" 3 30
            sleep 2
            clear
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata
            read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/programs/ending.sh
            #this needs a wiki of sorts, good suggetion, but more undestanding is required
            #bash /opt/plexguide/menus/programs/monitoring.sh
            ;;
        C)
            display=pyLoad
            program=pyload
            port=8000
            dialog --infobox "Installing: $display" 3 30
            sleep 2
            clear
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pyload
            read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        D)
            program=speed
            port=8223
            dialog --infobox "Installing: SpeedTEST Server" 3 38
            sleep 2
            clear
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags speedtestserver
            read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            #### skipped cron
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        Z)
            exit 0 ;;
    esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/support.sh
