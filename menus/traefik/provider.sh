#!/bin/bash
#
# [Traefik V2]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & DesignGears
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

rm -r /tmp/display1 1>/dev/null 2>&1
rm -r /tmp/display2 1>/dev/null 2>&1
rm -r /tmp/display3 1>/dev/null 2>&1
rm -r /tmp/display4 1>/dev/null 2>&1
dialog --title "Word of Caution" --msgbox "\nRecommended to visit https://domains.plexguide.com\n\nBasic information regarding each provider is listed!" 0 0

HEIGHT=12
WIDTH=26
CHOICE_HEIGHT=7
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE=" Select a Domain Provider "

OPTIONS=(A "CloudFlare"
         B "Gandi" 
         C "GoDaddy"
         D "NameCheap"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      dialog --title "Word of Caution" --msgbox "\nCloudflare is a great way to go! It may appear to work, but you need up to 12 hours if you just setup with CloudFlare!\n\nIf not, you may see an issue regarding the nameserver in the Portainer Logs!" 0 0
      echo "CLOUDFLARE_EMAIL" > /tmp/display1
      echo "CLOUDFLARE_API_KEY" > /tmp/display2
      echo "cloudflare" > /var/plexguide/provider
      dialog --infobox "Setting Up CloudFlare" 3 45
      sleep 1     
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker stop traefik2 1>/dev/null 2>&1
      docker rm traefik2 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      bash /opt/plexguide/menus/traefik/menu.sh
      bash /opt/plexguide/menus/traefik/version.sh
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    B)
      echo "GANDI_API_KEY" > /tmp/display1
      echo "gandiv5" > /var/plexguide/provider
      dialog --infobox "Setting Up Gandi" 3 45
      sleep 1
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker stop traefik2 1>/dev/null 2>&1
      docker rm traefik2 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      bash /opt/plexguide/menus/traefik/menu.sh
      bash /opt/plexguide/menus/traefik/version.sh
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    C)
      echo "GODADDY_API_KEY" > /tmp/display1
      echo "GODADDY_API_SECRET" > /tmp/display2
      echo "godaddy" > /var/plexguide/provider
      dialog --infobox "Setting Up Godaddy" 3 45
      sleep 1
      docker stop traefik2 1>/dev/null 2>&1
      docker rm traefik2 1>/dev/null 2>&1
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      bash /opt/plexguide/menus/traefik/menu.sh
      bash /opt/plexguide/menus/traefik/version.sh
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    D)
      dialog --title "Word of Caution" --msgbox "\nNameCheap requires a customer to spend at least 50 USD within the last two years to access their API!\n\nTold them the issue it causes and GoDaddy has no such requirement. If you cannot access the API, point your NameCheap Domain to CloudFlare!" 0 0
      echo "NAMECHEAP_API_USER" > /tmp/display1
      echo "NAMECHEAP_API_KEY" > /tmp/display2
      echo "namecheap" > /var/plexguide/provider
      dialog --infobox "Setting Up NameCheap" 3 45
      sleep 1
      docker stop traefik2 1>/dev/null 2>&1
      docker rm traefik2 1>/dev/null 2>&1
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      bash /opt/plexguide/menus/traefik/menu.sh
      bash /opt/plexguide/menus/traefik/version.sh
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    Z)
      exit 0 ;;
esac