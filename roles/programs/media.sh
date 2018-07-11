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
echo 'INFO - @Media PG Menu - GDrive Edition' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
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
            echo 'INFO - Selected: Plex' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags pgrole --extra-vars "mod=plex"
            read -n 1 -s -r -p "Press any key to continue"
                ;;
        B)
            echo 'INFO - Selected: Emby' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags emby --extra-vars "skipend=no"
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        C)
            echo 'INFO - Selected: Ubooquity' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags ubooquity --extra-vars "skipend=no"
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        D)
            echo 'INFO - Selected: AirSonic' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags airsonic --extra-vars "skipend=no"
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        E)
            echo 'INFO - Selected: BookSonic' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear && ansible-playbook /opt/plexguide/pg.yml --tags booksonic --extra-vars "skipend=no"
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        Z)
            exit 0 ;;
esac

#recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/media.sh
