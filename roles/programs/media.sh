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
echo 'INFO - @Media PG Menu - GDrive Edition' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
edition=$( cat /var/plexguide/pg.edition )

HEIGHT=12
WIDTH=38
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Media Programs"

OPTIONS=(A "Plex"
         B "Emby"
         C "Ubooquity"
         D "Airsonic"
         E "Booksonic"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=PLEX
            program=plex
            port=32400
            bash /opt/plexguide/menus/plex/main.sh

            file="/tmp/plexsetup"
            if [ -e "$file" ]
            then
                clear 1>/dev/null 2>&1
            else
                bash /opt/plexguide/roles/programs/media.sh
                exit
            fi

            #### G-Drive Edition
            if [ "$edition" == "PG Edition: GDrive" ]
              then
                dialog --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of PLEX. If your Library is super huge, when it's backing up; it will shut down your PLEX Container and could take several Minutes or Hours!" 0 0
            fi

            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        B)
            echo 'INFO - Selected: Emby' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags emby
            read -n 1 -s -r -p "Press any key to continue"
            bash /opt/plexguide/menus/time/cron.sh
            ;;
        C)
            echo 'INFO - Selected: Ubooquity' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags ubooquity
            read -n 1 -s -r -p "Press any key to continue"
            bash /opt/plexguide/menus/time/cron.sh
            ;;
        D)
            echo 'INFO - Selected: AirSonic' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags airsonic
            read -n 1 -s -r -p "Press any key to continue"
            bash /opt/plexguide/menus/time/cron.sh
            ;;
        E)
            echo 'INFO - Selected: BookSonic' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags booksonic
            read -n 1 -s -r -p "Press any key to continue"
            bash /opt/plexguide/menus/time/cron.sh
            ;;
        Z)
            exit 0 ;;
esac

#recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/media.sh
