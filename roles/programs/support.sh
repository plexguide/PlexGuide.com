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
echo 'INFO - @Support Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

domain=$( cat /var/plexguide/server.domain )

HEIGHT=14
WIDTH=37
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Supporting"

OPTIONS=(A "AllTube"
         B "Monitorr"
         C "Now Showing"
         D "Ombi"
         E "Tautulli (PlexPy)"
         F "The Lounge"
         G "PGTracker"
         H "Bazarr"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
  A)
    echo 'INFO - Selected: AllTube' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags alltube --extra-vars "quescheck=on cron=off display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  B)
    echo 'INFO - Selected: Monitorr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags monitorr --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  C)
    echo 'INFO - Selected: NowShowing' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags nowshowing --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  D)
    echo 'INFO - Selected: Ombi' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags ombi --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  E)
    echo 'INFO - Selected: Tautulli' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags tautulli --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  F)
    echo 'INFO - Selected: The Lounge' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags thelounge --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  G)
    echo 'INFO - Selected: PGTracker' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags pgtracker --extra-vars "quescheck=off cron=off display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  H)
    echo 'INFO - Selected: Bazarr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags bazarr --extra-vars "quescheck=off cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  Z)
    exit 0 ;;
esac
#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/support.sh
