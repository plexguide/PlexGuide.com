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
############################### Creates Starter Files if it Doesn't Exist
file="/var/plexguide/server.appguard" 1>/dev/null 2>&1
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    touch /var/plexguide/server.appguard 1>/dev/null 2>&1
    echo "[OFF]" > /var/plexguide/server.appguard
  fi

file="/var/plexguide/server.ports.status" 1>/dev/null 2>&1
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    touch /var/plexguide/var/plexguide/server.ports.status 1>/dev/null 2>&1
    echo "[OPEN]" > /var/plexguide/server.ports.status
  fi
############################### Calls Variables
appguard=$(cat /var/plexguide/server.appguard)
portstat=$(cat /var/plexguide/server.ports.status)

echo "INFO - @PG Security Menu" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
echo "INFO - AppGuard $appguard | Ports $portstat" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=10
WIDTH=43
CHOICE_HEIGHT=3
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Server Security"
MENU="Make a Selection:"

OPTIONS=(A "APP Ports - $portstat"
         B "APP Guard Protection - $appguard"
         B "Bitwarden - password manager"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
  A)
    echo "INFO - Selected Ports Menu Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/roles/ports/main.sh ;;
  B)
    echo "INFO - APPGuard Menu Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/menus/security/ht.sh ;;
  C)
    echo 'INFO - Selected: Bitwarden password manager' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags bitwarden --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  Z)
    clear
    echo "INFO - Exited PG Security Menu" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    exit 0 ;;
esac
bash /opt/plexguide/menus/security/main.sh
