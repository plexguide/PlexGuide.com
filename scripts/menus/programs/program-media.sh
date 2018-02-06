#!/bin/bash

  ## point to variable file for ipv4 and domain.com
  source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
  echo $ipv4
  echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Servers" --menu "Make your choice" 10 25 3 \
    "1)" "Plex"   \
    "2)" "Emby"  \
	"3)" "Ubooquity"  \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    bash /opt/plexguide/scripts/menus/plexsub-menu.sh
    ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags emby
    echo "EMBY: http://$ipv4:8096"
    echo "For Subdomain http://emby.$domain"
    echo "For Domain http://$domain:8096"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;
	 
	"3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ubooquity
    echo "EMBY: http://$ipv4:2202"
    echo "For Subdomain http://ubooquity.$domain"
    echo "For Domain http://$domain:2202"
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
