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
      echo "RuTorrent: http://$ipv4:8999"
      echo "For Subdomain https://rutorrent.$domain"
      echo "For Domain http://$domain:8999"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "2)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deluge
      echo "Deluge: http://$ipv4:8112"
      echo "For Subdomain https://deluge.$domain"
      echo "For Domain http://$domain:8112"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "3)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags jackett
      echo "Jackett: http://$ipv4:9117"
      echo "For Subdomain https://jackett.$domain"
      echo "For Domain http://$domain:9117"
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
