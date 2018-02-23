 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "NZB Choice" --menu "Make your choice" 12 25 5 \
    "1)" "NZBGet"   \
    "2)" "NZBHydra"  \
    "3)" "NZBHydra2"  \
    "4)" "SABNZBD"  \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbget
    echo "NZBGET: http://$ipv4:6789"
    echo "For Subdomain https://nzbget.$domain"
    echo "For Domain http://$domain:6789"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbhydra
    echo "NZBHydra: http://$ipv4:5075"
    echo "For Subdomain https://nzbhyra.$domain"
    echo "For Domain http://$domain:5075"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbhydra2
    echo "NZBHydra2: http://$ipv4:5076"
    echo "For Subdomain https://nzbhyra2.$domain"
    echo "For Domain http://$domain:5076"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "4)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sabnzbd
    echo "SABNZBD: http://$ipv4:8090"
    echo "For Subdomain https://sabnzbd.$domain"
    echo "For Domain http://$domain:8090"
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
