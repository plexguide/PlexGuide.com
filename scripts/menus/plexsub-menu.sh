
 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

whiptail --title "Plex Information" --msgbox "Visit http//:$ipv4:32400/web to complete the install. If installing Plex on a REMOTE SERVER have your Plex Claim Token ready by heading over to https://plex.tv/claim , and remember that the claim token is valid only for 4 minutes at a time! If, for some reason, the claim process should not work, read the plex wiki for the other 3 methods to claim!" 16 66

while [ 1 ]
do
CHOICE=$(
whiptail --title "Plex Version Select" --menu "Make your choice" 10 28 3 \
    "1)" "Plex Stable"   \
    "2)" "Plex Beta"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex
    echo "PLEX: http://$ipv4:32400/web"
    echo "For Subdomain http://plex.$domain/web"
    echo "For Domain http://$domain:32400/web"
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
    whiptail --title "Installed Plex Public" --msgbox "The Stable Version Of Plex Has Been Installed! Read The Wiki!" 9 50

    ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex-beta
    echo "PLEX: http://$ipv4:32400/web"
    echo "For Subdomain http://plex.$domain/web"
    echo "For Domain http://$domain:32400/web"
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
    whiptail --title "Installing Plex Beta" --msgbox "The Beta Version Of Plex Has Been Installed! Read The Wiki!" 9 50
    ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
