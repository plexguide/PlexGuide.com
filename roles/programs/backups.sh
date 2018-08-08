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
echo 'INFO - @Main Backup Program Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

 HEIGHT=12
 WIDTH=38
 CHOICE_HEIGHT=8
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Backup Programs"

 OPTIONS=(A "Bitwarden - Password manager"
          B "Duplicati"
          C "Syncthing"
          D "Resilio"
          E "NextCloud"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in
  A)
    echo 'INFO - Selected: Bitwarden' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags bitwarden --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  B)
    echo 'INFO - Selected: Duplicati' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags duplicati --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  C)
     echo 'INFO - Selected: Syncthing' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
     clear && ansible-playbook /opt/plexguide/pg.yml --tags syncthing --extra-vars "quescheck=on cron=on display=on"
     echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  D)
    echo 'INFO - Selected: Resilio' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/pg.yml --tags resilio --extra-vars "quescheck=on cron=on display=on"
    echo "" && read -n 1 -s -r -p "Press any key to continue" ;;
  E)
    display=NEXTCloud
    program=nextcloud
    port=4645
    bash /opt/plexguide/menus/nextcloud/main.sh
    dialog --infobox "Installing: $display" 3 30
    sleep 2
    clear
    ansible-playbook /opt/plexguide/pg.yml --tags nextcloud
    echo "" && read -n 1 -s -r -p "Press any key to continue"
    echo "$program" > /tmp/program
    echo "$program" > /tmp/program_var
    echo "$port" > /tmp/port
    bash /opt/plexguide/menus/programs/ending.sh ;;
 Z)
   exit 0 ;;
esac
#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/backups.sh
