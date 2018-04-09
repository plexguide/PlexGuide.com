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
######## This is a ONE TIME MENU
export NCURSES_NO_UTF8_ACS=1

#### Proof of concept, delete these 4 lines later
mkdir -p /var/plexguide/hd 1>/dev/null 2>&1
echo "/mnt/test1" > /var/plexguide/hd/hd1
echo "/mnt/cat/test2" > /var/plexguide/hd/hd2
echo "/tmp/test3" > /var/plexguide/hd/hd3
echo "/mnt" > /var/plexguide/hd/hd4

hd1=$( cat /var/plexguide/hd/hd1 )
hd2=$( cat /var/plexguide/hd/hd2 )
hd3=$( cat /var/plexguide/hd/hd3 )
hd4=$( cat /var/plexguide/hd/hd4 )

HEIGHT=11
WIDTH=60
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Make A Choice - Visit Again In Settings!"

OPTIONS=(A "Exit"
         B "HD1: $hd1"
         C "HD2: $hd2"
         D "HD3: $hd3"
         Z "HD4: $hd4")

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
    B)
      dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, but not ready!\n\nWhen your ready, visit SETTINGS for setup ANYTIME!" 0 0
      echo "nr" > /var/plexguide/server.hd
      echo "/mnt" > /var/plexguide/server.hd.path
      #### Rebuild Containers
      bash /opt/plexguide/scripts/baseinstall/rebuild.sh
      dialog --title "HD Selection" --msgbox "\nNo Changes were made. Standard location is /mnt!" 0 0
      exit
      ;;
    C)
      dialog --title "HD Selection" --msgbox "\nYou Selected: NO 2ND Harddrive for SETUP!\n\nNeed to Make Changes? Visit SETTINGS and change ANYTIME!" 0 0
      echo "no" > /var/plexguide/server.hd
      echo "/mnt" > /var/plexguide/server.hd.path
      #### Rebuild Containers
      bash /opt/plexguide/scripts/baseinstall/rebuild.sh
      dialog --title "HD Selection" --msgbox "\nNo Changes were made. Standard location is /mnt!" 0 0
      exit
      ;;
    D)
      exit
    ;;
    Z)
      exit
    ;;
esac