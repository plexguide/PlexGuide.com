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
echo 'INFO - @Critical Program Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=8
WIDTH=38
CHOICE_HEIGHT=2
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Critical"

OPTIONS=(A "Portainer"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
        echo 'INFO - Selected: Portainer' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags portainer --extra-vars "skipend=no quescheck=yes"
        read -n 1 -s -r -p "Press any key to continue"

        ;;
        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/critical.sh
