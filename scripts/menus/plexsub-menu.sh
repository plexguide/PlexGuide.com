
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

whiptail --title "Plex Information" --msgbox "If installing Plex on your OWN LOCAL Network, visit http//ip:32400/web to complete the install. If installing Plex on a REMOTE SERVER have your Plex Claim Token ready by heading over to https://plex.tv/claim , and remember that the claim token is valid only for 4 minutes at a time! If, for some reason, the claim process should not work, head over to http://wiki.plexguide.com and use a manual method!" 18 78

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
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
    whiptail --title "Installed Plex Public" --msgbox "The Stable Version Of Plex Has Been Installed! Read The Wiki!" 9 50

    ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex-beta
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
