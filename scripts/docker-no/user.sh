#!/bin/bash

mkdir -p /var/plexguide

file="/var/plexguide/plexguide.user"
if [ -e "$file" ]
then
    echo ""
else
clear

whiptail --title "Important" --msgbox "Welcome to the PlexGuide.com Installer.  If you have questions,
please read the Wikis or join our #Discord Channel." 8 78
touch /var/plexguide/plexguide.user

exit
fi

#checks list of fixes
bash /opt/plexguide/scripts/startup/fix/main.sh
