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

domain=$( cat /var/plexguide/server.domain )

HEIGHT=16
WIDTH=37
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Supporting"

OPTIONS=(A "CloudCMD"
         B "Netdata"
         C "NextCloud"
         D "Ombi"
         E "pyLoad"
         F "Resilio"
         G "SpeedTEST Server"
         H "Tautulli (PlexPy)"
         I "The Lounge"
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
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags cloudcmd &>/dev/null &
            sleep 3
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
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/programs/ending.sh
            #this needs a wiki of sorts, good suggetion, but more undestanding is required
            #bash /opt/plexguide/menus/programs/monitoring.sh
            ;;
        C)
            display=NEXTCloud
            program=nextcloud
            port=4645
            bash /opt/plexguide/menus/nextcloud/main.sh
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags next &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        D)
            display=Ombi
            program=ombi
            port=3579
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        E)
            display=pyLoad
            program=pyload
            port=8000
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pyLoad &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        F)
            display=RESILIO
            program=resilio
            port=8888
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags resilio &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        G)
            program=speed
            port=8223
            dialog --infobox "Installing: SpeedTEST Server" 3 38
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags speedtestserver &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            #### skipped cron
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        H)
            display=Tautulli
            program=tautulli
            port=8181
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        I)
            display=TheLounge
            program=thelounge
            port=9100
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lounge &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        Z)
            exit 0 ;;
    esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/support.sh
