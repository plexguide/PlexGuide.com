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
#hostname -I | awk '{print $1}' > /var/plexguide/server.ip
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1
path=$( cat /var/plexguide/server.hd.path ) 1>/dev/null 2>&1

#### Ensure Solo Edition's Path is /mnt
#if [ "$edition" == "PG Edition: HD Solo" ]
#  then
  #### If not /mnt, it will go through this process to change it!
#  if [ "$path" == "/mnt" ] 
#    then
#      clear 1>/dev/null 2>&1
#    else
#      dialog --title "-- NOTE --" --msgbox "\nWe have detected that /mnt IS NOT your default DOWNLOAD PATH for this EDITION.\n\nWe will fix that for you!" 0 0
#      echo "no" > /var/plexguide/server.hd
#      echo "/mnt" > /var/plexguide/server.hd.path
#      bash /opt/plexguide/scripts/baseinstall/rebuild.sh
#  fi
#fi

#### Disable Certain Services #### put a detect move.service file here later
#systemctl stop move 1>/dev/null 2>&1
#systemctl disable move 1>/dev/null 2>&1
#systemctl deamon-reload 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
HEIGHT=13
WIDTH=40
CHOICE_HEIGHT=7
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="$edition - $version"

OPTIONS=(A "PG Program Suite"
         B "PG HD Setup"
         C "PG Settings"
         D "PG Update"
         E "PG Edition Switch"
         F "Donation Menu"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
            bash /opt/plexguide/menus/programs/main.sh ;;
        B)
            #### Solo Drive Edition
            if [ "$edition" == "PG Edition: HD Solo" ]
              then
              dialog --title "-- NOTE --" --msgbox "\nNOT enabled for HD Solo Edition! You only have ONE DRIVE!" 0 0
              bash /opt/plexguide/menus/localmain.sh
              exit
            fi

            #### Multiple Editions HD
            bash /opt/plexguide/menus/drives/hds.sh
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags drives
            ;;
        C)
            bash /opt/plexguide/menus/settings/drives.sh
            ;;
        D)
            bash /opt/plexguide/scripts/upgrade/main.sh
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
        E)
            rm -r /var/plexguide/pg.edition 
            bash /opt/plexguide/scripts/baseinstall/edition.sh 
            exit 0 ;;
        F)
            bash /opt/plexguide/menus/donate/main.sh ;;
        Z)
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
esac

## repeat menu when exiting
bash /opt/plexguide/menus/localmain.sh
