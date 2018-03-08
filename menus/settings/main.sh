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

HEIGHT=13
WIDTH=55
CHOICE_HEIGHT=7
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Settings"
MENU="Make Your Selection Choice:"

OPTIONS=(A "Domain   : Set/Change a Domain"
         B "Ports    : Turn On/Off Application Ports"
         C "Processor: Enhance Processing Power"
         D "Redirect : Force Apps to use HTTPS Only?"
         E "Uncapped : Turn On/Off Upload Bandwidth Limit"
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
            ansible-playbook /opt/plexguide/ansible/config.yml --tags var

            bash /opt/plexguide/menus/redirect/main.sh

            file="/var/plexguide/redirect.yes"
                if [ -e "$file" ]
                    then
                sed -i 's/-OFF-/-ON-/g' /opt/plexguide/menus/redirect/main.sh
                    else
                sed -i 's/-ON-/-OFF-/g' /opt/plexguide/menus/redirect/main.sh
            fi
            ;;

        B)
            bash /opt/plexguide/menus/ports/main.sh ;;  
        C)
            bash /opt/plexguide/scripts/menus/processor/processor-menu.sh ;;
        D)
            bash /opt/plexguide/menus/redirect/main.sh

            file="/var/plexguide/redirect.yes"
                if [ -e "$file" ]
                    then
                sed -i 's/-OFF-/-ON-/g' /opt/plexguide/menus/redirect/main.sh
                    else
                sed -i 's/-ON-/-OFF-/g' /opt/plexguide/menus/redirect/main.sh
            fi
            ;;
        E) 
            bash /opt/plexguide/menus/transfer/main.sh ;;
        Z)
            clear
            exit 0
            ;;
esac
clear

bash /opt/plexguide/menus/settings/main.sh ;;
exit 0