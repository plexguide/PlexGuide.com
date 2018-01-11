 #!/bin/bash

## point to variable file for ipv4 and domain.com
# This takes .yml file and converts it to bash readable format
sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var2.yml > /opt/appdata/plexguide/var2.sh

#ipv4="/opt/appdata/plexguide/var2.yml"

# This replaces $ipv4 with local ip
ipv4=`hostname -I | awk '{print $1}'`

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 11 25 4 \
    "1)" "Radarr"   \
    "2)" "Sonarr"   \
    "3)" "MEDUSA"   \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr
    echo "Radarr: http://$ipv4:7878 | For Reverse Proxy radarr.$domain"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr
    echo "Sonarr: http://$ipv4:8989 | For Revese Proxy sonarr.$domain"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa
    echo "MEDUSA: http://$ipv4:8081 | For Reverse Proxy medusa.$domain"
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
