
 #!/bin/bash

whiptail --title "Donation Option Info" --msgbox "Would you be kind enough to TURN ON the Donation Option to mine for coins.  The program runs in a separate container and scales against (downward) your programs; being the lowest priroity.  The donation option utilizes UNUSED processing power and will not interfere with Plex or other programs.  This assists in further development and motivation. This option can be turned off anytime. Questions? Please visit our Wiki." 12 84

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation" --yesno "Will you Donate your Unused CPU Power to Assist Us?" 8 78) then
    whiptail --title "Donation Status - Yes" --msgbox "Thank you for helping and support the Team!" 8 84
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.yes 1>/dev/null 2>&1

     echo ymlprogram support > /opt/plexguide/tmp.txt
     echo ymldisplay Support >> /opt/plexguide/tmp.txt
     echo ymlport 0000 >> /opt/plexguide/tmp.txt
     echo "Setting up PlexGuide Donations - Thank You"
     bash /opt/plexguide/scripts/docker-no/program-installer.sh

else
    whiptail --title "Donation Status - No" --msgbox "We understand! If you change your mind, please visit our donation menu anytime!" 8 84
    rm -r /var/plexguide/donation* 1>/dev/null 2>&1
    touch /var/plexguide/donation.no 1>/dev/null 2>&1
fi
