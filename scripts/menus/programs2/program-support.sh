 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 12 23 5 \
    "1)" "Netdata"   \
    "2)" "OMBIv3"   \
    "3)" "Resilio"  \
    "4)" "Tautulli"  \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata
    echo "NetData: http://$ipv4:19999"
    #echo "For NGINX Proxy https://netdata.$domain"
    echo "For Domain http://$domain:19999"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi
    echo "Ombi: http://$ipv4:3579"
    #echo "For NGINX Proxy https://ombi.$domain"
    echo "For Domain http://$domain:3579"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags resilio
    echo "Resilio: http://$ipv4:8888"
    #echo "For NGINX Proxy https://resilio.$domain"
    echo "For Domain http://$domain:8888"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "4)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli
    echo "Tautulli: http://$ipv4:8181"
    #echo "For NGINX Proxy https://tautulli.$domain"
    echo "For Domain http://$domain:8181"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

     "5)")
      clear
      exit 0
      ;;
esac
done
exit
