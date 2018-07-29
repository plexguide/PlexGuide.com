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
echo 'INFO - Visited HD Selection Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

hdpath=$(cat /var/plexguide/server.hd.path)
dialog --title "Download Path Note" --msgbox "\nDownload Path can be on a second drive or current drive\n\nNOTE 2ND DRIVE: You must format and mount your drive. PG just points to a mounted folder!\n\nCurrent Download Path: $hdpath" 0 0

HEIGHT=9
WIDTH=50
CHOICE_HEIGHT=2
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Make A Choice - Visit Again In Settings!"

OPTIONS=(A "YES: Change the Download Path"
         Z "NO : Leave the Default Path Alone")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      bash /opt/plexguide/scripts/baseinstall/path.sh
      exit
      ;;
    Z)
      dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, but not ready!\n\nWhen your ready, visit SETTINGS for setup ANYTIME!" 0 0
      echo "/mnt" >
      dialog --title "HD Selection" --msgbox "\nNo Changes were made. Standard location is /mnt!" 0 0
      exit
      ;;
esac
