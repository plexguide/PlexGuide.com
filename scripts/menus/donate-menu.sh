
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation" --yesno "Do You Wish to Donate Unused CPU Power to Help Us?" 8 78) then
    echo "User selected Yes, exit status was $?."
else
    echo "User selected No, exit status was $?."
fi
