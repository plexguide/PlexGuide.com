 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Make A Selection" --menu "Make your choice" 11 29 4 \
    "1)" "Backup Programs"   \
    "2)" "Restore Programs"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
     clear
     bash /opt/plexguide/scripts/menus/backup-menu.sh
     ;;

    "2)")
    clear
    bash /opt/plexguide/scripts/menus/restore-menu.sh
    ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
