
 #!/bin/bash

whiptail --title "Donation Option Info" --msgbox "Would you be kind enough to TURN ON the Donation Option to mine for coins? From here, you can also disable/stop the mining of coins" 12 84

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation Selection" --yesno "Will you Donate your Unused CPU Power to Assist Us?" 8 78) then
    
    whiptail --title "Donation Status - Yes" --msgbox "Thank you for helping and support the Team!" 8 84
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.yes 1>/dev/null 2>&1
     echo ymlprogram support > /opt/plexguide/tmp.txt
     echo ymldisplay Support >> /opt/plexguide/tmp.txt
     echo ymlport 0000 >> /opt/plexguide/tmp.txt
     echo ""
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     echo "Setting up PlexGuide Donations - Thank You!"
     echo ""
     # read -n 1 -s -r -p "Press any key to continue"
else
    whiptail --title "Donation Status - No" --msgbox "We understand! If installed or running prior, we will disable it!" 8 84
    echo "Removing/Stopping Donation Support"
    docker stop support 1>/dev/null 2>&1
    docker rm support 1>/dev/null 2>&1
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.no 1>/dev/null 2>&1
    clear
    echo "Support Container Removed - Turn it back on anytime!"
    echo ""
    # read -n 1 -s -r -p "Press any key to continue"
fi
