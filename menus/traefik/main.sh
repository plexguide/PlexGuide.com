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
         C "Change Your Domain"
         D "Mini FAQ")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      clear
      ## keep going
    B)
      
    C)
      clear ;;
    D)
      clear
      ## type up stuff
esac




rm -r /tmp/display1
rm -r /tmp/display2
rm -r /tmp/display3
rm -r /tmp/display4

HEIGHT=14
WIDTH=38
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Select Your Domain Provider"

OPTIONS=(A "GoDaddy"
         B "NameCheap"
         C "BLANK"
         D "BLANK"
         E "BLANK"
         F "BLANK"
         G "BLANK"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      echo "GODADDY_API_KEY" > /tmp/display1
      echo "GODADDY_API_SECRET" > /tmp/display2
      echo "godaddy" > /var/plexguide/provider
      bash /opt/plexguide/menus/traefik/menu.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=namecheap
      exit 0 ;;
    B)
      echo "NAMECHEAP_API_USER" > /tmp/display1
      echo "NAMECHEAP_API_KEY" > /tmp/display2
      echo "namecheap" > /var/plexguide/provider
      bash /opt/plexguide/menus/traefik/menu.sh
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy
      exit 0 ;;
    C)
      clear ;;
    D)
      clear ;;
    E)
      clear ;;
    F)
      clear ;;
    G)
      clear ;;
    Z)
      exit 0 ;;
esac

bash /opt/plexguide/menus/traefik/main.sh
