 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 13 25 6 \
    "1)" "Heimdall" \
    "2)" "HTPCManager" \
    "3)" "Muximux" \
    "4)" "Organizr" \
    "5)" "Wordpress" \
    "6)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags heimdall
    echo "heimdall: http://$ipv4:1111"
    echo "For Subdomain http://heimdall.$domain"
    echo "For Domain http://$domain:8085"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;


    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags htpcmanager
    echo "HTPCManager: http://$ipv4:8085"
    echo "For Subdomain http://htpcmanager.$domain"
    echo "For Domain http://$domain:8085"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags muximux
    echo "Muximux: http://$ipv4:8015"
    echo "For Subdomain http://muximux.$domain"
    echo "For Domain http://$domain:8015"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "4)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags organizr
    echo "Organizr: http://$ipv4:8020"
    echo "For Subdomain http://organizr.$domain"
    echo "For Domain http://$domain:8020"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

     "5)")
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress
     echo "Vist: http://$ipv4 | Visit $domain"
     echo ""
     read -n 1 -s -r -p "Press any key to continue "
      ;;

     "6)")
      clear
      exit 0
      ;;
esac
done
exit
