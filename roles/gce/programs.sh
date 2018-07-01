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
echo 'INFO - @GCE Program Select Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

HEIGHT=15
WIDTH=35
CHOICE_HEIGHT=8
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="GCE Applications"

OPTIONS=(A "NZBGET"
         B "Sonarr"
         C "Radarr"
         D "SABNZBD"
         E "CloudST2"
         F "NetData"
         G "Lidarr"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
    echo 'INFO - Selected: NZBGet' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags nzbget
    read -n 1 -s -r -p "Press any key to continue"
    ;;

    B)
    echo 'INFO - Selected: Sonarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags sonarr
    read -n 1 -s -r -p "Press any key to continue"
    ;;

    C)
    echo 'INFO - Selected: Radarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags radarr
    read -n 1 -s -r -p "Press any key to continue"
    ;;

    D)
    echo 'INFO - Selected: SABNZBD' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags sabnzbd
    read -n 1 -s -r -p "Press any key to continue"
    ;;
    
    E)
    echo 'INFO - Selected: CloudST2' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudst2 --skip-tags cron
    read -n 1 -s -r -p "Press any key to continue"
    ;;

    F)
    echo 'INFO - Selected: Netdata' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags netdata --skip-tags cron
    read -n 1 -s -r -p "Press any key to continue"

    G)
    echo 'INFO - Selected: Lidarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags lidarr
    read -n 1 -s -r -p "Press any key to continue"
    ;;
    Z)
      exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/roles/gce/programs.sh
