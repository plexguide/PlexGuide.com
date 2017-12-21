#!/bin/bash

mkdir -p /var/plexguide

file="/var/plexguide/plexguide.user"
if [ -e "$file" ]
then
    clear
else
clear

whiptail --title "Important" --msgbox "Welcome to the PlexGuide.com Installer.  If you have questions,
please read the Wikis or join our #Discord Channel." 8 78

clear

exit
fi
