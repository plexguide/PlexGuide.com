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
# This takes .yml file and converts it to bash readable format
sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var.yml > /opt/appdata/plexguide/var.sh

HEIGHT=17
WIDTH=30
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PG Application Suite"
MENU="Make A Selection:"

OPTIONS=(A "Media Servers"
         B "Managers"
         C "NZB"
         D "Torrents"
         E "Supporting"
         F "UI Organziers"
         G "Critical"
         H "4K Versions"
         I "Beta"
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
            bash /opt/plexguide/menus/programs/media.sh ;;
        B)
            bash /opt/plexguide/menus/programs/manager.sh ;;
        C)
            bash /opt/plexguide/menus/programs/nzbs.sh ;;
        D)
            bash /opt/plexguide/menus/programs/torrent.sh ;;
        E)
            bash /opt/plexguide/menus/programs/support.sh ;;
        F)
            bash /opt/plexguide/menus/programs/ui.sh ;;
        G)
            bash /opt/plexguide/menus/programs/critical.sh ;;
        H)
            bash /opt/plexguide/menus/programs/versions4k.sh ;;
        I)
            bash /opt/plexguide/menus/programs/beta.sh ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/programs/main.sh
