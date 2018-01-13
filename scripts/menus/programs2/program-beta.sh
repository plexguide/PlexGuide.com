#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Choice" --menu "Make your choice" 10 30 4 \
    "1)" "VPN Torrent - old way"   \
    "2)" "VPN Torrent - new way"   \
    "3)" "Swap test files"   \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    clear
    bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh
    ;;

   "2)")
   clear
   bash /opt/plexguide/scripts/menus/programs/program-vpn.sh
   ;;

   "3)")
   clear
   # bash ansible-playbook /opt/plexguide/ansible/config2.yml --tags: var2 ## to generate the var file required above
   bash /opt/plexguide/scripts/test/move.sh
   echo ""
   read -n 1 -s -r -p "Press any key to continue "
   ;;

   "4)")
    clear
    exit 0
    ;;
esac
done
exit
