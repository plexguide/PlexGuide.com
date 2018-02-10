 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Make A Selection" --menu "Make your choice" 11 25 4 \
    "1)" "PlexDrive"   \
    "2)" "RClone"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
     clear
     bash /opt/plexguide/scripts/menus/plexdrive-menu.sh
     ;;

    "2)")
    clear
    bash /opt/plexguide/scripts/menus/rclone-menu.sh
    ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
