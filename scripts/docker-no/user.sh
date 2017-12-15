#!/bin/bash

mkdir -p /var/plexguide

file="/var/plexguide/plexguide.user"
if [ -e "$file" ]
then
    clear
else
clear

whiptail --title "Important" --msgbox "Welcome to the PlexGuide.com Installer.  If you have questions,
please read the wikis or join our #Slack Channel." 8 78

password=plexguide123
useradd -m -s /bin/bash plexguide
echo -e ""$password"\n"$password"\n" | passwd plexguide
usermod -aG plexguide
touch /var/plexguide/plexguide.user

clear

exit
fi
