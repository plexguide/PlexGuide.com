#!/bin/bash

# This takes .yml file and converts it to bash readable format
sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var.yml > /opt/appdata/plexguide/var.sh

HEIGHT=16
WIDTH=40
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PG Application Install Suite"
MENU="Choose one of the following options:"

OPTIONS=(1 "Media Servers"
         2 "Managers"
         3 "NZB"
         4 "Torrents"
         5 "Supporting"
         6 "UI Organziers"
         7 "Critical"
         8 "Beta"
         9 "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            bash /opt/plexguide/menus/programs/media.sh ;;
        2)
            bash /opt/plexguide/menus/programs/mangers.sh ;;
        3)
            bash /opt/plexguide/menus/programs/nzbs.sh ;;
        4)
            bash /opt/plexguide/menus/programs/torrent.sh ;;
        5)
            bash /opt/plexguide/menus/programs/support.sh ;;
        6)
            bash /opt/plexguide/menus/programs/ui.sh ;;
        7)
            bash /opt/plexguide/menus/programs/critical.sh ;;
        8)
            bash /opt/plexguide/menus/programs/beta.sh ;;
        9)
            clear
            exit 0 ;;
esac