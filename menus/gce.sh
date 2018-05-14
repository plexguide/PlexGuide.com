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

bash /opt/plexguide/menus/gce/gcechecker.sh

edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

HEIGHT=16
WIDTH=40
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="$edition - $version"

OPTIONS=(A "PG RClone Cache"
         B "PG Programs"
         C "PG SuperTransfer2"
         D "PG Server NET Benchmarks"
         E "PG Trek"
         F "PG Troubleshooting Actions"
         G "PG Backup & Restore"
         H "PG Updates"
         I "PG Edition Switch"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
            bash /opt/plexguide/menus/rclone/old-or-new.sh ;;
        B)
            bash /opt/plexguide/menus/gce/programs.sh ;;
        C)
        clear
        bash /opt/plexguide/scripts/supertransfer/config.sh
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2
        journalctl -f -u supertransfer2
            ;;
        D)
            bash /opt/plexguide/menus/benchmark/main.sh ;;
        E)
            bash /opt/plexguide/menus/info-tshoot/info.sh ;;
        F)
            bash /opt/plexguide/menus/info-tshoot/tshoot.sh ;;

        G)
            bash /opt/plexguide/menus/backup-restore/main.sh ;;
        H)
            bash /opt/plexguide/scripts/upgrade/main.sh
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
        I)
            bash /opt/plexguide/scripts/baseinstall/edition.sh
            ;;
        Z)
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
esac

## repeat menu when exiting
bash /opt/plexguide/menus/gce.sh
