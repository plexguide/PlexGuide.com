#!/bin/bash

mkdir -p /var/plexguide 1>/dev/null 2>&1

file="/var/plexguide/plexguide.user"
if [ -e "$file" ]
then
    echo ""
else
clear

whiptail --title "Important" --msgbox "Welcome to the PlexGuide.com Installer.  If you have questions,
please read the Wikis or join our #Discord Channel." 8 78
touch /var/plexguide/plexguide.user 1>/dev/null 2>&1

exit
fi