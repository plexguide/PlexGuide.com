 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Choice" --menu "Make your choice" 11 25 4 \
    "1)" "NZBGet"   \
    "2)" "NZBHydra"  \
    "3)" "SABNZBD"  \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbget
    echo "NZBGET: http://ipv4:6789 | For NGINX Proxy nzbget.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbhydra
    echo "NZBHydra: http://ipv4:5075 | For NGINX Proxy nzbhyra.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sabnzbd
    echo "SABNZBD: http://ipv4:8090 | For NGINX Proxy sabnzbd.domain.com"
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
