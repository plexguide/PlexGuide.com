#!/bin/bash
#
# [PlexGuide Critical Menu]
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

HEIGHT=9
WIDTH=38
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Critical"

OPTIONS=(A "Portainer"
         B "Domain/Traefik"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=Portainer
            program=portainer
            port=9000
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer &>/dev/null &
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        B)
            bash /opt/plexguide/menus/traefik/main.sh
            bash /opt/plexguide/menus/programs/critical.sh
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            exit
            ;;   
        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/critical.sh
