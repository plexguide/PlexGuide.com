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
echo 'INFO - @Main 4K Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=10
WIDTH=38
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="4K Versions - PG Supporting"

OPTIONS=(A "Ombi4k"
         B "Sonarr4k"
         C "Radarr4k"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            echo 'INFO - Selected: Ombi4k' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags ombi4k --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"

            ;;
        B)
            echo 'INFO - Selected: Sonarr4k' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags sonarr4k --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"

            ;;
        C)
            echo 'INFO - Selected: Radarr4k' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags radarr4k --extra-vars "quescheck=on cron=on display=on"
            read -n 1 -s -r -p "Press any key to continue"

            ;;
        Z)
            exit 0 ;;
esac

echo 'INFO Looping: 4K Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/versions4k.sh
