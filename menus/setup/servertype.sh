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
#################################################################################  dialog --title "PG Update Status" --msgbox "\nUser Failed To Agree! You can view the program, but doing anything will mess things up!" 0 0
dialog --title "--- WARNING !!! ---" --msgbox "\nSelect the type of Server you are running!\n\nPay attention to what you are selecting! It will affect your choices!\n\nNeed to ReRun? Visit > Troubleshooting > Server Setup -- " 0 0

HEIGHT=11
WIDTH=55
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Settings"
MENU="Make Your Selection Choice:"

OPTIONS=(A "Remote: Dedicated Server"
         B "Remote: VPS or Virtual Machine"
         C "Local : Dedicated Server"
         D "Local : VPS or Virtual Machine")

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
        echo "remote" > /var/plexguide/server.type
        echo "dedicated" > /var/plexguide/server.build
        ;;
    B)
        echo "remote" > /var/plexguide/server.type
        echo "vm" > /var/plexguide/server.build
        ;;
    C)
        echo "local" > /var/plexguide/server.type
        echo "dedicated" > /var/plexguide/server.build
        ;;
    D)
        echo "local" > /var/plexguide/server.type
        echo "vm" > /var/plexguide/server.build
        ;;   
esac

touch /var/plexguide/server.settings.set
exit 0
