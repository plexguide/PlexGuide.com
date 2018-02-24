
 #!/bin/bash

#whiptail --title "Donation Option Info" --msgbox "Would you be kind enough to TURN ON the Donation Option to mine for coins.  The program runs in a separate container and scales against (downward) your programs; being the lowest priroity.  The donation option utilizes UNUSED processing power and will not interfere with Plex or other programs.  This assists in further development and motivation. This option can be turned off anytime. Questions? Please visit our Wiki." 14 76

dialog --title "Hello" --msgbox 'Hello world!' 6 20

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation" --yesno "Will you Donate your Unused CPU Power to Assist Us?" 8 76) then
    
    whiptail --title "Donation Status - Yes" --msgbox "Thank you for helping and support the Team!" 8 76
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.yes 1>/dev/null 2>&1

     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags support
     echo "Setting up PlexGuide Donations - Thank You"

else
    whiptail --title "Donation Status - No" --msgbox "We understand! If you change your mind, please visit our donation menu anytime!" 9 76
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.no 1>/dev/null 2>&1
fi
