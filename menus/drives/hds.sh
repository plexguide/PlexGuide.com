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

hd1=$( cat /var/plexguide/hd/hd1 )
hd2=$( cat /var/plexguide/hd/hd2 )
hd3=$( cat /var/plexguide/hd/hd3 )
hd4=$( cat /var/plexguide/hd/hd4 )

HEIGHT=12
WIDTH=60
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Set Your Mount Paths!"

OPTIONS=(Z "Exit"
         Y "Clear All Paths"
         A "HD1: $hd1"
         B "HD2: $hd2"
         C "HD3: $hd3"
         D "HD4: $hd4")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    Z)
      exit
      ;;
    Y)
      rm -r /var/plexguide/hd/* 1>/dev/null 2>&1
      ;;
    A)
      echo "1" > /tmp/hd.drive
      bash /opt/plexguide/menus/drives/path.sh
      ;;
    B)
      echo "2" > /tmp/hd.drive
      bash /opt/plexguide/menus/drives/path.sh
      ;;
    C)
      echo "3" > /tmp/hd.drive
      bash /opt/plexguide/menus/drives/path.sh
      ;;
    D)
      echo "4" > /tmp/hd.drive
      bash /opt/plexguide/menus/drives/path.sh
      ;;
esac

###/mnt/move=RW:/mnt/plexdrive=RO

dr1="$hd1=RW:"
dr2="$hd2=RW:"
dr3="$hd3=RW:"
dr4="$hd4=RW:"

combined="$dr1$dr2$dr3$dr4"
combined=${combined::-1} 
echo "$combined" > /var/plexguide/hd/combined
bash /opt/plexguide/menus/drives/hds.sh

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags drives