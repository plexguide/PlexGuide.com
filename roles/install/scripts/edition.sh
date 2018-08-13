#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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

######################################################## Declare Variables
sname="PG Installer: Set PG Edition"
pg_edition=$( cat /var/plexguide/pg.edition )
pg_edition_stored=$( cat /var/plexguide/pg.edition.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
if [ "$pg_edition" == "$pg_edition_stored" ]; then
      echo "" 1>/dev/null 2>&1
    else
      dialog --infobox "WARNING! Setting Your PlexGuide Edition! You Can Only Set the Edition One Time!\n\nChoose Carefully!" 0 0
      sleep 5
      clear

echo 'INFO - Visited PG Edition Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=10
WIDTH=31
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Select Your Edition!"

OPTIONS=(A "GDrive Edition"
         B "HD Solo Edition"
         C "HD Multi Edition"
         D "GCE Feeder Edition")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      echo 'INFO - Select PG Edition: GDrive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      echo "PG Edition: GDrive" > /var/plexguide/pg.edition
      echo "gdrive" > /var/plexguide/pg.server.deploy
      ;;
    B)
      echo 'INFO - Select PG Edition: HD Solo' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      ansible-playbook /opt/plexguide/pg.yml --tags folders_solo &>/dev/null &
      echo "PG Edition: HD Solo" > /var/plexguide/pg.edition
      echo "drive" > /var/plexguide/pg.server.deploy
      exit
      ;;
    C)
      echo 'INFO - Select PG Edition: HD Multi' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      echo "PG Edition: HD Multi" > /var/plexguide/pg.edition
      echo "drives" > /var/plexguide/pg.server.deploy
      ;;
    D)
      echo 'INFO - Select PG Edition: GCE Feeder' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      echo "PG Edition: GCE Feed" > /var/plexguide/pg.edition
      echo "feeder" > /var/plexguide/pg.server.deploy
      ;;
esac
      cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
  fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
