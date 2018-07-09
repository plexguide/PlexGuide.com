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
echo 'INFO - @Deploy Choice Menu for Mount Selection' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

##################################################### DEPLOYMENT SYSTEM - START
        HEIGHT=11
        WIDTH=44
        CHOICE_HEIGHT=5
        BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
        TITLE="Deploy a Mounting System"

        OPTIONS=(A "PGDrive   /w PG Move (Recommended)"
                 B "PGDrive   /w PG ST2  (Advanced)"
                 C "PlexDrive /w PG Move (Traditional)"
                 Z "Exit")

        CHOICE=$(dialog --backtitle "$BACKTITLE" \
                        --title "$TITLE" \
                        --menu "$MENU" \
                        $HEIGHT $WIDTH $CHOICE_HEIGHT \
                        "${OPTIONS[@]}" \
                        2>&1 >/dev/tty)
        case $CHOICE in
                A)
                    echo "Move" > /var/plexguide/menu.select
                    bash /opt/plexguide/roles/pgdrivenav/main.sh
                    ;;
                B)
                    echo "SuperTransfer2" > /var/plexguide/menu.select
                    bash /opt/plexguide/roles/pgdrivenav/main.sh
                    ;;
                C)
                    "plexdrive" > /var/plexguide/menu.select
                    bash /opt/plexguide/roles/plexdrive/scripts/rc-pd.sh 
                    ;;
                Z)
                    ;; ## Do Not Put Anything Here
        esac

## repeat menu when exiting
echo 'INFO - Redirection: Going Back to Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
exit
