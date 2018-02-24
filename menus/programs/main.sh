#!/bin/bash

# This takes .yml file and converts it to bash readable format
sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var.yml > /opt/appdata/plexguide/var.sh

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=8
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Backup & Restore Menu"
MENU="Choose one of the following options:"

OPTIONS=(1 "Media Servers"
         2 "Restore"
         3 "Restore"
         4 "Restore"
         5 "Restore"
         6 "Restore"
         7 "Restore"
         8 "Exit")

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
            bash /opt/plexguide/scripts/menus/backup-restore/backup/backup.sh
            ;;
        2)
            bash /opt/plexguide/scripts/menus/backup-restore/restore/restore.sh
            ;;
        3)
            clear
            exit 0
            ;;
esac




clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 16 26 9 \
    "1)" "Media Servers"  \
    "2)" "Managers"  \
    "3)" "NZBs"  \
    "4)" "Torrents"  \
    "5)" "Supporting"  \
    "6)" "UI Organizers"  \
    "7)" "Critical"  \
    "8)" "Beta Testing"  \
    "9)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-media.sh
    ;;

    "2)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-managers.sh
    ;;

    "3)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-nzbs.sh
    ;;

    "4)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-torrent.sh
    ;;

    "5)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-support.sh
    ;;

    "6)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-ui.sh
    ;;

    "7)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-critical.sh
    ;;

    "8)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-beta.sh
    ;;

    "9)")
      clear
      exit 0
      ;;
esac
done
exit
