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
export NCURSES_NO_UTF8_ACS=1
echo 'INFO - Visited PG Edition Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

dialog --title "Quick Note" --msgbox "\nWARNING! Setting Your PlexGuide Edition! You Can Only Set the Edition One Time!\n\nChoose Carefully!" 0 0

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
      echo 'INFO - Select PG Edition: GDrive' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      echo "PG Edition: GDrive" > /var/plexguide/pg.edition
      echo "gdrive" > /var/plexguide/pg.server.deploy
      ;;
    B)
      echo 'INFO - Select PG Edition: HD Solo' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags folders_solo &>/dev/null &
      echo "PG Edition: HD Solo" > /var/plexguide/pg.edition
      echo "drive" > /var/plexguide/pg.server.deploy
      exit
      ;;
    C)
      echo 'INFO - Select PG Edition: HD Multi' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      echo "PG Edition: HD Multi" > /var/plexguide/pg.edition
      echo "drives" > /var/plexguide/pg.server.deploy
      ;;
    D)
      echo 'INFO - Select PG Edition: GCE Feeder' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      echo "PG Edition: GCE Feed" > /var/plexguide/pg.edition
      echo "feeder" > /var/plexguide/pg.server.deploy
      ;;
esac
