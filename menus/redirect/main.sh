#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Detique
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
HEIGHT=11
WIDTH=32
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Forced HTTPS Redirect: On/Off"
MENU="Y"

OPTIONS=(A "Keep Forced Redirect Off"
         B "Force HTTPS Redirect On"
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
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            sed -i 's/entryPoint = "https"/#entryPoint = "https"/g' /opt/appdata/traefik/traefik.toml
            dialog --title "PG Application Status" --msgbox "\nForced https Redirect is OFF!" 0 0  
        B)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            sed -i '#s/entryPoint = "https"/entryPoint = "https"/g' /opt/appdata/traefik/traefik.toml
            dialog --title "PG Application Status" --msgbox "\nForced https Redirect is ON!" 0 0
        Z)
            clear
            exit 0
            ;;
esac
