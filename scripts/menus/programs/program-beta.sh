#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Beta Menu" --menu "Make your choice" 13 60 6 \
    "1)" "VPN Torrent - New way"   \
    "2)" "VPN Torrent - Old way"   \
    "3)" "DO NOT USE - For Developers Use Only!"   \
    "4)" "NGINX-Proxy - For those that still want to use it!"   \
    "5)" "Couchpotato"  \
    "6)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-vpn.sh
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
   ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nginx
   echo ""
   read -n 1 -s -r -p "Press any key to continue "
   ;;

  "5)")
   ansible-playbook /opt/plexguide/ansible/vpn.yml --tags couchpotato
   echo "CouchPotato: http://$ipv4:5050"
   echo "For Subdomain http://couchpotato.$domain"
   echo "For Domain http://$domain:5050"
   echo ""
   read -n 1 -s -r -p "Press any key to continue "
   ;;

   "6)")
    clear
    exit 0
    ;;
esac
done
exit
