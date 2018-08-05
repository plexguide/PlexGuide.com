#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & Bryde ツ
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
echo 'INFO - @Manager Programs Menu - GDrive Edition' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=16
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Manager Programs"

OPTIONS=(A "Couchpotato"
         B "Headphones"
         C "Lazy Librarian"
         D "Lidarr"
         E "MEDUSA"
         F "Mylar"
         G "Radarr"
         H "Sickrage"
         I "Sonarr"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
  A)
    echo 'INFO - Selected: CouchPotato' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags couchpotato --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  B)
    echo 'INFO - Selected: Lidarr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags lidarr --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  C)
    echo 'INFO - Selected: LazyLibrarian' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags lazylibrarian --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  D)
    echo 'INFO - Selected: Lidarr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags lidarr --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  E)
    echo 'INFO - Selected: MEDUSA' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags medusa --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  F)
    echo 'INFO - Selected: Mylar' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags mylar --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  G)
    echo 'INFO - Selected: Radarr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags radarr --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  H)
    echo 'INFO - Selected: SickRage' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags sickrage --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  I)
    echo 'INFO - Selected: Sonarr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags sonarr --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  Z)
    exit 0 ;;
esac
#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/manager.sh
