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
echo 'INFO - @Backup-Restore Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
recovery=$( cat /var/plexguide/restore.id )

export NCURSES_NO_UTF8_ACS=1
HEIGHT=13
WIDTH=52
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Backup & Restore Menu"
MENU="Current Server Recovery ID: $recovery"

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
            clear
            bash /opt/plexguide/roles/backup/scripts/main.sh
            ansible-playbook /opt/plexguide/pg.yml --tags backup --extra-vars "switch=on"
            echo ""
            read -n 1 -s -r -p "Program Backed Up - Press [Any Key] to Continue"
            ;;
        B)
            bash /opt/plexguide/menus/backup-restore/restore.sh
            ;;
        C)
            bash /opt/plexguide/roles/backup/scripts/bmass.sh
            ;;
        D)
            bash /opt/plexguide/menus/backup-restore/restoremass.sh
            ;;
        E)
            bash /opt/plexguide/menus/backup-restore/recovery.sh
            ;;
        Z)
            clear
            exit 0
            ;;

esac
bash /opt/plexguide/roles/backup-restore-nav/main.sh
