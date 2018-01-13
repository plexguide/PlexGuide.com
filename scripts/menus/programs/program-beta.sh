 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Choice" --menu "Make your choice" 10 50 3 \
    "1)" "VPN Torrent"   \
    "2)" "DO NOT USE - Swap files round for testing"   \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    clear
    bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh
    ;;

     "2)")
     clear
     bash /opt/plexguide/scripts/test/move.sh
     echo "Move files have been swapped, please go back to the main menu!"
     read -n 1 -s -r -p "Press any key to continue "
     ;;

     "3)")
      clear
      exit 0
      ;;
esac
done
exit
