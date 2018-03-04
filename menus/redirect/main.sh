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

dialog --title "PG Application Status" --msgbox "\nIf turning forced redirect ON, ensure that an https:// address works first!" 0 0

HEIGHT=11
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Forced HTTPS Redirect: -OFF- "
MENU="For use with SUBDOMAINS, not IPv4:Ports"

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
\[entryPoints.http.redirect\]
clear
case $CHOICE in
        A)   
            rm /var/plexguide/redirect.yes 1>/dev/null 2>&1
            sed -i 's/\#entryPoint = "https"/#entryPoint = "https"/g' /opt/appdata/traefik/traefik.toml
            sed -i 's/\#\[entryPoints.http.redirect]\#[entryPoints.http.redirect\]/g' /opt/appdata/traefik/traefik.toml
            dialog --title "Traefik Status" --msgbox "\nForced https Redirect is OFF! Restarting Traefik!" 0 0
            ;;
        B)
            touch /var/plexguide/redirect.yes 1>/dev/null 2>&1
            sed -i 's/#entryPoint = "https"/entryPoint = "https"/g' /opt/appdata/traefik/traefik.toml
            sed -i 's/\#\[entryPoints.http.redirect\]/\[entryPoints.http.redirect\]/g' /opt/appdata/traefik/traefik.toml
            dialog --title "Traefik Status" --msgbox "\nForced https Redirect is ON! Restarting Traefik" 0 0
            ;;
        Z)
            clear
            exit 0
            ;;
esac
clear

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik --skip-tags=redirect
dialog --title "Traefik Status" --msgbox "\nTraefik is now Restarted!" 0 0