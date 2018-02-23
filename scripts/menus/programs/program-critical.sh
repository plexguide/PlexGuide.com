 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 10 33 3 \
    "1)" "Portainer"   \
    "2)" "Traefik Reverse Proxy"   \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer
    echo "Portainer: http://$ipv4:9000"
    echo "For Subdomain https://portainer.$domain"
    echo "For Domain http://$domain:9000"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

     "3)")
      clear
      exit 0
      ;;
esac
done
exit
