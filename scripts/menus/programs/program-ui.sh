 #!/bin/bash

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
    echo "Muximux: http://ipv4:8015 | For NGINX Proxy muximux.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags organizr
    echo "Organizr: http://ipv4:8020 | For NGINX Proxy organizr.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

     "3)")
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress
     echo "Vist: http://ipv4 | Visit domain.com"
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
