 #!/bin/bash

 # This takes .yml file and converts it to bash readable format
 sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var2.yml > /opt/appdata/plexguide/var3.sh

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var3.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Install Menu" --menu "Make your choice" 11 25 4 \
    "1)" "RTorrentVPN"  \
    "2)" "DelugeVPN"  \
    "3)" "Var file setup"  \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

     "1)")
      ansible-playbook /opt/plexguide/ansible/test3.yml --tags rtorrentvpn
      echo "RTorrentVPN: http://$ipv4:3000"
      echo "For NGINX Proxy https://rtorrentvpn.$domain"
      echo "For Traefik http://$domain:3000"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "2)")
      ansible-playbook /opt/plexguide/ansible/test3.yml --tags delugevpn
      echo "DelugeVPN: http://$ipv4:8112"
      echo "For NGINX Proxy https://delugevpn.$domain"
      echo "For Traefik http://$domain:8112"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "3)")
     ansible-playbook /opt/plexguide/ansible/config2.yml --tags var2
     bash /opt/plexguide/scripts/menus/programs/program-vpn.sh
     read -n 1 -s -r -p "Press any key to continue "
      ;;

     "4)")
      clear
      exit 0
      ;;
esac
done
exit
