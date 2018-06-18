#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
echo 'INFO - @Backup-Restore Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
recovery=$( cat /var/plexguide/restore.id )

export NCURSES_NO_UTF8_ACS=1
HEIGHT=13
WIDTH=60
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Backup & Restore Menu"
MENU="Current Recovery ID Server: $recover:"

OPTIONS=(A "Solo Backup"
         B "Solo Restore"
         C "Mass Backup  (Time Intensive)"
         D "Mass Restore (Time Intensive)"
         E "Change Recovery ID"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)
            bash /opt/plexguide/menus/backup-restore/backup.sh 
            ;;
        B)
            bash /opt/plexguide/menus/backup-restore/restore.sh
            ;;
        C)
            bash /opt/plexguide/menus/backup-restore/backupmass.sh 
            ;;
        D)
            bash /opt/plexguide/menus/backup-restore/restoremass.sh
            ;;
        E) 

        Z)
            clear
            exit 0
            ;;

esac
bash /opt/plexguide/menus/backup-restore/main.sh