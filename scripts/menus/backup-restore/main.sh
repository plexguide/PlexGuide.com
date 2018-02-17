#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup Menu" --menu "Make your choice" 11 25 4 \
    "1)" "Backup"  \
    "2)" "Restore"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
        bash /opt/plexguide/scripts/menus/backup-restore/backup/backup.sh
        ;;

    "2)")
        bash /opt/plexguide/scripts/menus/backup-restore/restore/restore.sh
        ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
