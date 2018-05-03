#!/bin/bash
#
# [PlexGuide Interface]
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
#################################################################################
export NCURSES_NO_UTF8_ACS=1

HEIGHT=10
WIDTH=38
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="4K Versions - PG Supporting"

OPTIONS=(A "Ombi4k"
         B "Radarr4k"
         C "Sonarr4k"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=Ombi4K
            program=ombi4k
            port=3574
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi4k &>/dev/null &
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        B)
            display=Radarr4k
            program=radarr4k
            port=7874
            bash /opt/plexguide/menus/images/radarr4k.sh
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr4k 1>/dev/null 2>&1
            chown 1000:1000 /opt/appdata/radarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
            chmod 0755 /opt/appdata/radarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1 
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        C)
            display=Sonarr4k
            program=sonarr4k
            port=8984
            bash /opt/plexguide/menus/images/sonarr4k.sh
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr4k 1>/dev/null 2>&1
            chown 1000:1000 /opt/appdata/sonarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
            chmod 0755 /opt/appdata/sonarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
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
bash /opt/plexguide/menus/programs/versions4k.sh
