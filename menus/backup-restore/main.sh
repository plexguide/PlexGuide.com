#!/bin/bash

#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Backtitle here"
TITLE="Make Your Choice"
MENU="Choose one of the following options:"

OPTIONS=(1 "Backup"
         2 "Restore"
         3 "Exit")

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
whiptail --title "Selection Menu" --menu "Make your choice" 11 25 4 \
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
