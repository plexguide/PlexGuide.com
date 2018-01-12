 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 11 25 4 \
    "1)" "Muximux" \
    "2)" "Organizr" \
    "3)" "Wordpress" \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags muximux
    echo "Muximux: http://$ipv4:8015"
    echo "For NGINX Proxy https://muximux.$domain"
    echo "For Traefik http://$domain:8015"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags organizr
    echo "Organizr: http://$ipv4:8020"
    echo "For NGINX Proxy https://organizr.$domain"
    echo "For Traefik http://$domain:8020"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

     "3)")
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress
     echo "Vist: http://$ipv4 | Visit $domain"
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
