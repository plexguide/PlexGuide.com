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
echo 'INFO - @Manager Programs Menu - GDrive Edition' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

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
      echo 'INFO - Selected: CouchPotato' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags couchpotato
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    B)
      echo 'INFO - Selected: Lidarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags lidarr
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    C)
      display=LazyLibrarian
      program=lazy
      port=5299
      dialog --infobox "Installing: $display" 3 30
      sleep 2
      clear
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lazy
      read -n 1 -s -r -p "Press any key to continue"
      echo "$program" > /tmp/program
      echo "$program" > /tmp/program_var
      echo "$port" > /tmp/port
      bash /opt/plexguide/menus/time/cron.sh
      bash /opt/plexguide/menus/programs/ending.sh
      ;;
    D)
      echo 'INFO - Selected: Lidarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags lidarr
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    E)
      echo 'INFO - Selected: MEDUSA' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags medusa
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    F)
      echo 'INFO - Selected: Mylar' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags mylar
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    G)
      echo 'INFO - Selected: Radarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags radarr
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    H)
      echo 'INFO - Selected: SickRage' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags sickrage
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    I)
      echo 'INFO - Selected: Sonarr' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags sonarr
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    Z)
      exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/manager.sh
