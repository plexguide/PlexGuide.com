 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 12 25 5 \
    "1)" "Lidarr"   \
    "2)" "Medusa"   \
    "3)" "Sonarr"   \
    "4)" "MEDUSA"   \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

  "2)")
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lidarr
  echo "MEDUSA: http://ipv4:8686 | For Reverse Proxy lidarr.domain.com"
  echo ""
  read -n 1 -s -r -p "Press any key to continue "
  ;;

  "2)")
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa
  echo "MEDUSA: http://ipv4:8081 | For Reverse Proxy medusa.domain.com"
  echo ""
  read -n 1 -s -r -p "Press any key to continue "
  ;;

  "3)")
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr
  echo "Sonarr: http://ipv4:8989 | For Revese Proxy sonarr.domain.com"
  echo ""
  read -n 1 -s -r -p "Press any key to continue "
  ;;

    "4)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr
    echo "Radarr: http://ipv4:7878 | For Reverse Proxy radarr.domain.com"
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
