#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
HEIGHT=12
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Assistance Menu"
MENU="Make a Selection Choice:"

OPTIONS=(A "Information"
         B "Server Network Benchmarks"
         C "View Service Status"
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
            bash /opt/plexguide/scripts/menus/info-menu.sh ;;
        B)
            bash /opt/plexguide/menus/benchmark/main.sh ;;
        C)
            bash /opt/plexguide/scripts/menus/status-menu.sh ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info/main.sh