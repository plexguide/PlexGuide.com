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

### PUT IF SETUP ALREADY, EXIT

HEIGHT=11
WIDTH=55
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Make A Choice - Visit Again In Settings!"

OPTIONS=(A "YES: Second HD Will Be Used! It's READY!"
         B "YES: Second HD Will Be Used! It's NOT READY"
         C "NO:  No SECOND HD!"
         D "MINI FAQ: Why this Question?"
         E "Exit")

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
      dialog --title "Quick Story" --msgbox "\nThe purpose of this is to seperate your downloaded/downloading content to occur on another HD.\n\nRunning PLEX and having everything download to one drive can result in slow performace! If you have a second HD, you can use this to help improve your performance (and great for those using SMALL SSD's as their primary drives)." 0 0
      bash /opt/plexguide/scripts/baseinstall/harddrive.sh
      exit
    ;;
    E)
    file="/var/plexguide/base.hd"
    if [ -e "$file" ]
        then
          echo "" 1>/dev/null 2>&1
        else
          dialog --title "HD Selection" --msgbox "\nYou Selected: NO 2ND Harddrive for SETUP (EXITED)!\n\nNeed to Make Changes? Visit SETTINGS and change ANYTIME!" 0 0
          echo "no" > /var/plexguide/server.hd
          echo "/mnt" > /var/plexguide/server.hd.path
          #### Rebuild Containers
          bash /opt/plexguide/scripts/baseinstall/rebuild.sh
          dialog --title "HD Selection" --msgbox "\nNo Changes were made. Standard location is /mnt!" 0 0
    fi
      exit
    ;;
esac