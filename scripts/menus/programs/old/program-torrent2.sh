 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Torrent Menu" --menu "Make your choice" 11 25 4 \
    "1)" "RuTorrent"  \
    "2)" "Deluge"  \
    "3)" "Jackett"  \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

     "1)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rutorrent
      echo "RuTorrent: http://ipv4:8999 | For NGINX Proxy rutorrent.domain.com"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "2)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deluge
      echo "Deluge: http://ipv4:8112 | For NGINX Proxy deluge.domain.com"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "3)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags jackett
      echo "Jackett: http://ipv4:9117 | For NGINX Proxy jackett.domain.com"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "4)")
      clear
      exit 0
      ;;
esac
done
exit
