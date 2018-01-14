#!/bin/bash

## point to variable file for ipv4 and domain.com 
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "VNC Server" --menu "Make your choice" 10 37 3 \
    "1)" "VNC Server Container: Create"   \
    "2)" "VNC Server Container: Destory"   \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)
 
result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags vnc
    echo "Access VNC Via IP:     http://$ipv4:8686"
    echo "Acesss VNC Via Domain: http://$domain:8686"
    echo ""
    touch /var/plexguide/vnc.yes 1>/dev/null 2>&1
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2")
    docker stop VNC
    docker rm VNC
    echo ""
    echo "Docker Container Destroyed"
    rm -r /var/plexguide/vnc.yes 1>/dev/null 2>&1
    read -n 1 -s -r -p "Press any key to continue "
     ;;

     "3)")
      clear
      exit 0
      ;;
esac
done
exit
