 #!/bin/bash

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
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rtorrentvpn
      echo "RTorrentVPN: http://$ipv4:3000 | For NGINX Proxy https://rtorrentvpn.$domain"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "2)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags delugevpn
      echo "DelugeVPN: http://$ipv4:8112 | For NGINX Proxy https://delugevpn.$domain"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "3)")
     bash ansible-playbook /opt/plexguide/ansible/config2.yml
     bash  sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var2.yml > /opt/appdata/plexguide/var3.sh
     bash ansible-playbook /opt/plexguide/ansible/test3.yml
      ;;

     "4)")
      clear
      exit 0
      ;;
esac
done
exit
