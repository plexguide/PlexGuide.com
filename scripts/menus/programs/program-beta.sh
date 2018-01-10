 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Choice" --menu "Make your choice" 12 30 5 \
    "1)" "Lidarr"   \
    "2)" "VPN Torrent"   \
    "3)" "Do Not Use"   \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lidarr
    echo "Lidarr: http://ipv4:8686 | For Reverse Proxy lidarr.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    clear
    bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh
    ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa
    echo "Medusa: http://ipv4:8081| For NGINX Proxy medusa.domain.com"
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
