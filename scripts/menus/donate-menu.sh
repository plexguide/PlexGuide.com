
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

whiptail --title "Donation Option Info" --msgbox "Would you be kind enough to TURN ON the Donation Option to mine for coins.  The program runs in a separate container and scales against (downward) your programs being the lowest priroity.  The donation option utilizes your UNUSED processing power and will not interfere with Plex or your other programs.  If enabled, you assist us in further development and motivation.  You may turn this option OFF future wise anytime.  If you have questions on how it works, please visit our Wiki." 12 84



# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation" --yesno "Will you Donate your Unused CPU Power to Assist Us?" 8 78) then
    echo "User selected Yes, exit status was $?."
else
    echo "User selected No, exit status was $?."
fi
