
 #!/bin/bash

dialog --title "Hello" --msgbox 'Hello world!' 6 20

whiptail --title "Donation Option Info" --msgbox "Would you be kind enough to TURN ON the Donation Option to mine for coins? From here, you can also disable/stop the mining of coins." 13 76

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation Selection" --yesno "Will you Donate your Unused CPU Power to Assist Us?" 8 76) then
    
    whiptail --title "Donation Status - Yes" --msgbox "Thank you for helping and support the Team!" 8 76
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.yes 1>/dev/null 2>&1
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags support
     echo ""
     echo "Thank you for your support!"
     echo ""
     read -n 1 -s -r -p "Press any key to continue"
else
    whiptail --title "Donation Status - No" --msgbox "We understand! If installed or running prior, we will disable it!" 9 76
    echo "Removing/Stopping Donation Support"
    docker stop support 1>/dev/null 2>&1
    docker rm support 1>/dev/null 2>&1
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.no 1>/dev/null 2>&1
    clear
    echo "Support Container Removed - Turn it back on anytime!"
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
fi
