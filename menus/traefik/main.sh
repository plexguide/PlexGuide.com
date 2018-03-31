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
## point to variable file for ipv4 and domain.com

HEIGHT=14
WIDTH=38
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Select Your Domain Provider"

OPTIONS=(A "Traefik V2"
         B "Legacy Traefik"
         C "Change Domain (NOT READY)"
         D "Mini FAQ")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      clear ;;
      ## keep going
    B)
      docker stop traefik 1>/dev/null 2>&1
      docerk rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      display=Legacy-Traefik
      program=traefik
      port=NONE
      dialog --infobox "Installing: $display" 3 30
      sleep 3
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik 1>/dev/null 2>&1
      exit ;;
    C)
      clear ;;
    D)
      dialog --title "Mini FAQ: Page 1 of 2" --msgbox "\nVisit traefik.plexguide.com for more detailed info\n\nTraefik v2 is the new version that allows all of your subdomains (unlimited) to receive an SSL CERTIFICATE. This allows you to create custom subdomains, not limited by having a max of 20, and cuts down on the RATE ERRORS. There is some minor work on your end to make this work!" 0 0
      dialog --title "Mini FAQ: Page 2 of 2" --msgbox "\nLegacy Traefik works fine, but you will not be able to create custom subdomains and more limited in the amount of subdomains you can create per week. It is easier to setup though.\n\nVisit https://traefik.plexguide.com for more information." 0 0
      bash /opt/plexguide/menus/traefik/main.sh
      exit
      ;;
esac

rm -r /tmp/display1 1>/dev/null 2>&1
rm -r /tmp/display2 1>/dev/null 2>&1
rm -r /tmp/display3 1>/dev/null 2>&1
rm -r /tmp/display4 1>/dev/null 2>&1
dialog --title "Word of Caution" --msgbox "\nRecommended to visit https://domains.plexguide.com\n\nBasic information regarding each provider is listed!" 0 0

HEIGHT=14
WIDTH=35
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Select Your Domain Provider"

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
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      sleep 3
      echo "CLOUDFLARE_EMAIL" > /tmp/display1
      echo "CLOUDFLARE_API_KEY" > /tmp/display2
      echo "cloudflare" > /var/plexguide/provider
      bash /opt/plexguide/menus/traefik/menu.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy,namecheap,gandi
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;

    B)
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      sleep 3
      echo "GANDI_API_KEY" > /tmp/display1
      echo "gandiv5" > /var/plexguide/provider
      bash /opt/plexguide/menus/traefik/menu.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy,namecheap,cloudflar
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    C)
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      sleep 3
      echo "GODADDY_API_KEY" > /tmp/display1
      echo "GODADDY_API_SECRET" > /tmp/display2
      echo "godaddy" > /var/plexguide/provider
      bash /opt/plexguide/menus/traefik/menu.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=namecheap,gandi,cloudflare
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    D)
      dialog --title "Word of Caution" --msgbox "\nNameCheap requires a customer to spend at least 50 USD within the last two years to access their API!\n\nTold them the issue it causes and GoDaddy has no such requirement. If you cannot access the API, point your NameCheap Domain to CloudFlare!" 0 0
      docker stop traefik 1>/dev/null 2>&1
      docker rm traefik 1>/dev/null 2>&1
      docker rm -r /opt/appdata/traefik 1>/dev/null 2>&1
      sleep 3
      echo "NAMECHEAP_API_USER" > /tmp/display1
      echo "NAMECHEAP_API_KEY" > /tmp/display2
      echo "namecheap" > /var/plexguide/provider
      bash /opt/plexguide/menus/traefik/menu.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy,gandi,cloudflare
      bash /opt/plexguide/menus/traefik/rebuild.sh
      exit 0 ;;
    Z)
      exit 0 ;;
esac

bash /opt/plexguide/menus/traefik/main.sh
