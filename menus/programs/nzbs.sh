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
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1
echo 'INFO - @Main NZBs Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

HEIGHT=10
WIDTH=38
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="NZB Applications - PG Supporting"

OPTIONS=(A "NZBGet"
         B "NZBHydra v2"
         C "SABNZBD"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=NZBGET
            program=nzbget
            bash /opt/plexguide/menus/images/nzbget.sh
            dialog --infobox "Installing: $display" 3 30
            sleep 2
            clear
            port=6789
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbget
            read -n 1 -s -r -p "Press any key to continue"
              echo "$program" > /tmp/program
              echo "$program" > /tmp/program_var
              echo "$port" > /tmp/port
              bash /opt/plexguide/menus/time/cron.sh
              bash /opt/plexguide/menus/programs/ending.sh
            ;;
        B)
            display=NZBHYDRA2
            program=nzbhydra2
            bash /opt/plexguide/menus/images/nzbhydra2.sh
            dialog --infobox "Installing: $display" 3 30
            sleep 2
            clear
            port=5076
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbhydra2
            read -n 1 -s -r -p "Press any key to continue"
              echo "$program" > /tmp/program
              echo "$program" > /tmp/program_var
              echo "$port" > /tmp/port
              bash /opt/plexguide/menus/time/cron.sh
              bash /opt/plexguide/menus/programs/ending.sh
            ;;
        C)
            echo 'INFO - Selected: SABNZBD' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags sabnzbd
            read -n 1 -s -r -p "Press any key to continue"
            bash /opt/plexguide/menus/time/cron.sh
            ;;

        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/nzbs.sh
