#!/bin/bash

mkdir -p /var/plexguide

file="/var/plexguide/plexguide.user"
if [ -e "$file" ]
then
    clear
else
clear

whiptail --title "Important" --msgbox "Welcome to PlexGuide.com! Before you install the program, we will assist
you in making a user named: plexguide

- You are creating a user name known as (plexguide) with sudo permissions!
- Do Not Forget Your Password (Use Troubleshoot To Change)

ENCRYPTION USERS WARNING! If using encrypted method, do not upgrade. Create the
user as required, but when asking for upgrade; select NO. Encryption needs work!" 8 78


password=$(whiptail --passwordbox "Create a Password for the User: plexguide" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
                                                                        # A trick to swap stdout and stderr.
# Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $password
else
    echo "User selected Cancel."
fi

echo "(Exit status was $exitstatus)"

useradd -m -s /bin/bash plexguide
echo -e ""$password"\n"$password"\n" | passwd plexguide
usermod -aG plexguide
touch /var/plexguide/plexguide.user

clear

exit
fi
