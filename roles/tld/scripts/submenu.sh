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
echo 'INFO - @Traefik SubInterface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=9
WIDTH=55
CHOICE_HEIGHT=3
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Traefik SubInterface Menu"

OPTIONS=(A "Deploy Traefik: Reverse Proxy"
         B "Deploy TLD App: Top Level Domain Application"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
        echo 'INFO - Selected: PG Traefik - Reverse Proxy' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        touch /var/plexguide/traefik.lock
        clear &&ansible-playbook /opt/plexguide/pg.yml --tags traefik
        file="/var/plexguide/traefik.lock"
        if [ -e "$file" ]
          then
            echo "" && read -n 1 -s -r -p "Did Not Complete Deployment! Press [ANY] Key to EXIT!"
          else
            echo "" && read -n 1 -s -r -p "We Must Rebuild Your Containers! Press [ANY] Key!"
            bash /opt/plexguide/roles/traefik/scripts/rebuild.sh
            echo "" && read -n 1 -s -r -p "Containers Rebuilt! Press any key to continue!"
        fi
        ;;
        B)
        clear
        echo 'INFO - Selected: TLD Application' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        echo "off" > /var/plexguide/tld.control
        ansible-playbook /opt/plexguide/pg.yml --tags tld
        echo ""
        read -n 1 -s -r -p "Containers Must Be Rebuilt! - Press [Any] Key to Continue"
        echo ""
        control=$(cat /var/plexguide/tld.control)
        if [ "$control" == "on" ]; then
          bash /opt/plexguide/roles/tld/scripts/rebuild.sh
        else
          sleep 0.5
          echo ""
          read -n 1 -s -r -p "User Exited! - Press [Any] Key to Continue"
        fi
        ;;
        Z)
echo 'INFO - Selected: Exit PlexGuide' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/ending/ending.sh
            exit 0 ;;
esac

## repeat menu when exiting
echo 'INFO - Looping: Sub Traefik Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/tld/scripts/submenu.sh ;;
exit
