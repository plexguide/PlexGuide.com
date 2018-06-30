#!/bin/bash

## point to variable file for ipv4 and domain.com 
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

clear

whiptail --title "Warning" --msgbox "This is only a temporary measure for you to do other things.  You cannot deploy plexguide here and the connection is unencrypted.  We will look to improve this!" 10 66

while [ 1 ]
do
CHOICE=$(
whiptail --title "VNC Server" --menu "Make your choice" 10 37 3 \
    "1)" "VNC Server Container: Create"  \
    "2)" "VNC Server Container: Destory" \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)
 
result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/pg.yml --tags vnc
    echo "Access VNC Via IP:     http://$ipv4:20001"
    echo "Acesss VNC Via Domain: http://$domain:20001"
    echo ""
    touch /var/plexguide/vnc.yes 1>/dev/null 2>&1
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    clear
    echo "Please Wait"
    docker stop VNC 1>/dev/null 2>&1
    docker rm VNC 1>/dev/null 2>&1
    whiptail --title "Container Destroyed" --msgbox "Container Destroyed" 8 40
    clear
    rm -r /var/plexguide/vnc.yes 1>/dev/null 2>&1
     ;;

     "3)")
      clear
      exit 0
      ;;
esac
done
exit
