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

############################################################ Recall Server Port Status
status=$(cat /var/plexguide/server.ports.status)

dialog --title "Very Important" --msgbox "\nYour Applications Port Status: $status\n\nYou must decide to keep your PORTS opened or closed.\n\nOnly close your PORTS if your REVERSE PROXY (subdomains) are working!" 0 0

############ Menu
HEIGHT=10
WIDTH=52
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Make a Choice"
MENU="Ports are Currently >>> $status"

OPTIONS=(A "Ports: OPEN"
         B "Ports: CLOSED"
         Z "Exit - No Change")

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
        dialog --infobox "Please Wait!" 3 35
        sleep 1
            echo "[OPEN]" > /var/plexguide/server.ports.status
            rm -r /var/plexguide/server.ports
            touch /var/plexguide/server.ports
            ;;
        B)
        dialog --infobox "Please Wait!" 3 50
        sleep 1
            echo "[CLOSED]" > /var/plexguide/server.ports.status
            echo "127.0.0.1:" > /var/plexguide/server.ports
            ;;
        Z)
            clear
            exit 0 ;;
esac

bash /opt/plexguide/menus/traefik/rebuild.sh

echo "$app: All Applications Ports Are $status" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
dialog --title "Final Note" --msgbox "\nYour Containers Are Built!" 0 0
