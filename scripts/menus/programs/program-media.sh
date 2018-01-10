 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Servers" --menu "Make your choice" 10 25 3 \
    "1)" "Plex"   \
    "2)" "Emby"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    bash /opt/plexguide/scripts/menus/plexsub-menu.sh
    ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags emby
    echo "EMBY: http://ipv4:8096 | For NGINX Proxy emby.domain.com"
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
