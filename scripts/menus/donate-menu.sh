
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

whiptail --title "Donation Information" --msgbox "We are asking your help to ENABLE/Turn On the ability to mine coins with your unused processing power.  Do not worry, it coded where it DOES NOT affect the performance of your process (for geeks: it scales).  By turning this on, it will help our community grow, by my wife a nice dinner (keep her happy), and keeps our motivation up and high!" 10 84



# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Donation" --yesno "Do You Wish to Donate Unused CPU Power to Help Us?" 8 78) then
    echo "User selected Yes, exit status was $?."
else
    echo "User selected No, exit status was $?."
fi
