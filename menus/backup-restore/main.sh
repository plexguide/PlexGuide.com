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
WIDTH=5
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Backup & Restore Menu"
MENU="Choose one of the following options:"

OPTIONS=(A "Solo Program Backup"
         B "Solo Program Restore"
         C "Mass Program Back    (Time Intensive)"
         D "Mass Program Restore (Time Intensive)"
         E "Change Recovery ID (Current: $restore.id)"
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
        #systemctl is-active --quiet rclone
        #if [ $? -eq 0 ]; then
        bash /opt/plexguide/menus/backup-restore/restore.sh
        #else
        #  dialog --title "Rclone Service Check Failure" --msgbox "\nRclone service not running. Please install rclone first!" 0 0
          #bash /opt/plexguide/menus/backup-restore/main.sh
        #fi 
        ;;
        C)
        bash /opt/plexguide/menus/backup-restore/backupmass.sh ;;
        D)
        #systemctl is-active --quiet rclone
        #if [ $? -eq 0 ]; then
        bash /opt/plexguide/menus/backup-restore/restoremass.sh
        #else
        #  dialog --title "Rclone Service Check Failure" --msgbox "\nRclone service not running. Please install rclone first!" 0 0
        #  bash /opt/plexguide/menus/backup-restore/main.sh
        #fi
        ;;
        Z)
            clear
            exit 0
            ;;

esac
bash /opt/plexguide/menus/backup-restore/main.sh