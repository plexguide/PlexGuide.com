 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Install Menu" --menu "Make your choice" 19 55 12 \
    "1)" "Force PreInstaller"   \
    "2)" "Reinstall Portainer"  \
    "3)" "Uninstall Docker, Containers & Force Preinstall" \
    "4)" "Update Your E-Mail, Domain and other Variables" \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
   "1)")
      clear
      rm -r /var/plexguide/dep*
      echo
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "2)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer
      echo "Portainer: http://ipv4:9000 | For NGINX Proxy portainer.domain.com"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "3)")
      echo "Uninstall Docker"
      echo
      rm -r /etc/docker
      apt-get purge docker-ce
      rm -rf /var/lib/docker
      clear
      read -n 1 -s -r -p "Docker Uninstalled - All Containers Removed"
      rm -r /var/plexguide/dep*
      clear
      echo ""
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "4)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags var
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
