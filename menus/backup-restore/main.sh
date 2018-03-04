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

export NCURSES_NO_UTF8_ACS=1
HEIGHT=12
WIDTH=45
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Backup & Restore Menu"
MENU="Choose one of the following options:"

OPTIONS=(A "Individual: Solo App Backup"
         B "Individual: Solo App Restore"
         C "Mass (All): Backup (Takes Time)"
         D "Mass (All): Restore (Takes Time)"
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
            bash /opt/plexguide/menus/backup-restore/backup.sh ;;
        B)
            bash /opt/plexguide/scripts/menus/backup-restore/restore/restore.sh ;;
        C)
            bash /opt/plexguide/scripts/backup-restore/backup.sh ;;
        D)
            bash /opt/plexguide/scripts/backup-restore/restore.sh ;;
        Z)
            clear
            exit 0
            ;;
esac