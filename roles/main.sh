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
echo 'INFO - @Main PG Menu - GDrive Edition' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

HEIGHT=17
WIDTH=40
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="$edition - $version"

OPTIONS=(A "Deploy a Mount System"
         B "PG Traefik - Reverse Proxy"
         C "PG Program Suite"
         D "PG Plex Enhancement Tools"
         E "PG Server Security"
         F "PG Server Information"
         G "PG Troubleshooting Actions"
         H "PG Settings & Tools"
         I "PG Backup & Restore"
         J "PG Updates"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
echo 'INFO - Selected: Deploy a Mount System' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
           bash /opt/plexguide/roles/deploychoice.sh ;;
        B)
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
        C)
echo 'INFO - Selected: PG Program Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/main.sh ;;
        D)
echo 'INFO - Selected: PLEX Enhancements' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/menus/plex/enhancement.sh ;;
        E)
echo 'INFO - Selected: PG Security Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/menus/security/main.sh ;;
        F)
echo 'INFO - Selected: PG Server Information' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/info-tshoot/info.sh ;;
        G)
echo 'INFO - Selected: Info & Troubleshoot' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/info-tshoot/tshoot.sh ;;
        H)
echo 'INFO - Selected: Settings' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/menus/settings/main.sh ;;
        I)
echo 'INFO - Selected: Backup & Restore' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/backup-restore-nav/main.sh ;;
        J)
echo 'INFO - Selected: PG Upgrades Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/scripts/upgrade/main.sh
            bash /opt/plexguide/roles/ending/ending.sh
            exit 0 ;;
        Z)
echo 'INFO - Selected: Exit PlexGuide' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/ending/ending.sh
            exit 0 ;;
esac

## repeat menu when exiting
echo 'INFO - Looping: Main GDrive Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/main.sh
exit
