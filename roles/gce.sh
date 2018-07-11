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
echo 'INFO - @GCE Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

bash /opt/plexguide/roles/gce/gcechecker.sh

edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="$edition - $version"

OPTIONS=(A "Deploy a Mount System"
         B "PG Traefik - Reverse Proxy"
         C "PG GCE Programs"
         D "PG Server NET Benchmarks"
         E "PG Trak"
         F "PG Troubleshooting Actions"
         G "PG Backup & Restore"
         H "PG Updates"
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
echo 'INFO - Selected to View Programs for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/gce/programs.sh
            ;;
        D)
echo 'INFO - Selected to View BenchMarks for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/menus/benchmark/main.sh ;;
        E)
echo 'INFO - Selected to View PGTrak Menu for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/menus/pgtrak/main.sh
            ;;
        F)
echo 'INFO - Selected to View Info-TShoot for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/info-tshoot/tshoot.sh ;;
        G)
echo 'INFO - Selected to View Backup-Restore for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/backup-restore-nav/main.sh ;;
        H)
echo 'INFO - Selected: PG Upgrades Menu Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/scripts/upgrade/main.sh
            bash /opt/plexguide/roles/ending/ending.sh
            exit 0 ;;
        Z)
echo 'INFO - Selected: Exit GCE Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/ending/ending.sh
            exit 0 ;;
esac

echo 'INFO - Looping: GCE Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
## repeat menu when exiting
bash /opt/plexguide/roles/gce.sh
