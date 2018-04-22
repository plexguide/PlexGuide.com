#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

HEIGHT=15
WIDTH=58
CHOICE_HEIGHT=8
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Settings"
MENU="Make Your Selection Choice:"

OPTIONS=(A "Domain/Traefik: Setup/Change Domain & Trefik"
         B "Hard Drive 2nd: Use a Second HD for Processing"
         C "Notifications : Enable the Use of Notifications"
         E "Processor     : Enhance Processing Power"
         F "Kernel Mods   : Enhance Network Throughput"
         G "WatchTower    : Auto-Update Application Manager"
         H "App Themes    : Install Dark Theme(s) For Apps "
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
    A)
        bash /opt/plexguide/menus/traefik/main.sh
        ;;
    B)
        #### Solo Drive Edition
        if [ "$edition" == "PG Edition: HD Solo" ]
          then
          dialog --title "-- NOTE --" --msgbox "\nNOT enabled for HD Solo Edition! You only have ONE DRIVE!" 0 0
          bash /opt/plexguide/menus/settings/drives.sh
          exit
        fi 
        ;;
    C)
        bash /opt/plexguide/menus/notifications/main.sh
        echo "Pushover Notifications are Working!" > /tmp/pushover
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
        ;;
    D)
        bash /opt/plexguide/menus/ports/main.sh ;;
    E)
        bash /opt/plexguide/scripts/menus/processor/processor-menu.sh ;;
    F)
        bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh ;;
    H)
        bash /opt/plexguide/menus/watchtower/main.sh ;;
    J)
        bash /opt/plexguide/menus/themes/main.sh ;;
    Z)
        clear
        exit 0
        ;;
    esac
clear

bash /opt/plexguide/menus/settings/drives.sh
exit 0
