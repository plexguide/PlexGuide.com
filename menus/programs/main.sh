#!/bin/bash

# This takes .yml file and converts it to bash readable format
sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var.yml > /opt/appdata/plexguide/var.sh

HEIGHT=16
WIDTH=40
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PG Application Install Suite"
MENU="Choose one of the following options:"

OPTIONS=(A "Media Servers"
         B "Managers"
         C "NZB"
         D "Torrents"
         E "Supporting"
         F "UI Organziers"
         G "Critical"
         H "Beta"
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
            bash /opt/plexguide/menus/programs/beta.sh ;;
        Z)
            clear
            exit 0 ;;
esac