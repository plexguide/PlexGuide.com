
 #!/bin/bash

whiptail --title "Plex Information" --msgbox "If installing Plex on your OWN LOCAL Network, visit http//ip:32400/web to complete the install. If installing Plex on a remote server, visit the wiki at http://wiki.plexguide.com on how to SSH into your server to complete the setup. Visit http://ipv4:32400/web afterwards!" 13 76

if (whiptail --title "Plex Version" --yesno "Select [Yes] for Plex the Public or [No] for the Plex Beta Install " 8 76) then
    
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexpublic
    whiptail --title "Donation Status - Yes" --msgbox "Thank you for helping and support the Team!" 8 76     
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
else
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexpass
    whiptail --title "Installing Plex Beta" --msgbox "The Beta Version of Plex has been installed!" 9 76
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
fi
