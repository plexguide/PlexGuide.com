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

mkdir -p /var/plexguide/hd 1>/dev/null 2>&1
#hd1=$( cat /var/plexguide/hd/hd1 )

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Set Your Mount Paths!"

OPTIONS=(A "Google Drive Edition"
         B "Local HD Edition (Not Ready)"
         C "Mini FAQ"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      echo "PG Edition: Google Drive" > /var/plexguide/pg.edition
      bash /opt/plexguide/menus/drives/path.sh
      ;;
    B)
      echo "PG Edition: Local Drives" > /var/plexguide/pg.edition
      bash /opt/plexguide/menus/drives/path.sh
      ;;
    C)
      clear 1>/dev/null 2>&1
      ;;
    Z)
      echo "4" > /tmp/hd.drive
      bash /opt/plexguide/menus/drives/path.sh
      ;;
esac

bash /opt/plexguide/scripts/baseinstall/edition.sh  