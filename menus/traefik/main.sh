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
export NCURSES_NO_UTF8_ACS=1

domain=$( cat /var/plexguide/server.domain )
dialog --infobox "Tracked Domain: $domain" 3 46
sleep 2

file="/var/plexguide/base.domain"
if [ -e "$file" ]
    then
          version=$( cat /var/plexguide/provider )
          if [ "$version" == "null" ]
          then
            dialog --infobox "Using Legacy Traefik" 3 28
            sleep 2
          else
            dialog --infobox "Using Traefik v2\n\nProvider $version" 3 40
            sleep 2
          fi
    else
      dialog --title "Setup Note" --msgbox "\nNo Version of Traefik is Installed! Warning, goto http://domains.plexguide.com for Info!" 0 0
      touch /var/plexguide/base.domain
fi

HEIGHT=11
WIDTH=32
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Make A Choice"

OPTIONS=(A "Traefik V2"
         B "Legacy Traefik"
         C "Change Domain Name"
         D "Mini FAQ"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      bash /opt/plexguide/menus/traefik/provider.sh
      bash /opt/plexguide/menus/traefik/main.sh
      touch /var/plexguide/base.domain
      exit ;;
    B)
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker stop traefik2 1>/dev/null 2>&1
      docker rm traefik2 1>/dev/null 2>&1
      rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      display=Legacy-Traefik
      program=traefik
      port=NONE
      dialog --infobox "Installing: $display" 3 30
      sleep 2
      echo "null" > /var/plexguide/provider  
      bash /opt/plexguide/menus/traefik/version.sh
      bash /opt/plexguide/menus/traefik/rebuild.sh
      dialog --title "Status" --msgbox "\nLegacy Traefik Installed!\n\nView the Traefik Portainer Logs for more information!" 0 0
      bash /opt/plexguide/menus/traefik/main.sh
      touch /var/plexguide/base.domain
      exit ;;
    C)
      bash /opt/plexguide/menus/traefik/domain.sh
      bash /opt/plexguide/menus/traefik/version.sh
      bash /opt/plexguide/menus/traefik/rebuild.sh
      dialog --title "Status" --msgbox "\nYour Domain is Now Set!" 0 0
      bash /opt/plexguide/menus/traefik/main.sh
      touch /var/plexguide/base.domain
      ;;
    D)
      dialog --title "Mini FAQ: Page 1 of 2" --msgbox "\nVisit traefik.plexguide.com for more detailed info\n\nTraefik v2 is the new version that allows all of your subdomains (unlimited) to receive an SSL CERTIFICATE. This allows you to create custom subdomains, not limited by having a max of 20, and cuts down on the RATE ERRORS. There is some minor work on your end to make this work!" 0 0
      dialog --title "Mini FAQ: Page 2 of 2" --msgbox "\nLegacy Traefik works fine, but you will not be able to create custom subdomains and more limited in the amount of subdomains you can create per week. It is easier to setup though.\n\nVisit https://traefik.plexguide.com for more information." 0 0
      bash /opt/plexguide/menus/traefik/main.sh
      exit
      ;;
    Z)
    file="/var/plexguide/base.domain"
    if [ -e "$file" ]
        then
          echo "" 1>/dev/null 2>&1
        else
          dialog --title "No Traefik" --msgbox "\nYou Decided to Exit without making any choices!\n\nWarning, No Version of Traefik has Installed! Visit settings to fix anytime!" 0 0
          touch /var/plexguide/base.domain
    fi
      exit
      ;;
esac
