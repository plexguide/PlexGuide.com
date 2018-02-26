#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Beta Menu" --menu "Make your choice" 14 60 7 \
    "1)" "VPN Torrent - New way"   \
    "2)" "VPN Torrent - Old way"   \
    "3)" "DO NOT USE - For Developers Use Only!"   \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    clear
    bash /opt/plexguide/menus/programs/vpn-next.sh
    ;;

   "2)")
   clear
   bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh
   ;;

   "3)")
   clear
   bash /opt/plexguide/scripts/test/move.sh
   echo "Testing files have now been swapped"
   echo "Please go back to the main menu to see changes"
   read -n 1 -s -r -p "Press any key to continue "
   ;;

   "4)")
    clear
    exit 0
    ;;
esac
done
exit
