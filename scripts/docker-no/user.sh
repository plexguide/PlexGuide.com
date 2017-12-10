#!/bin/bash

mkdir -p /var/plexguide

file="/var/plexguide/plexguide.user"
if [ -e "$file" ]
then
    clear
else
clear
cat << EOF
Welcome to PlexGuide.com! Before you install the program, we will assist
you in making a user named: plexguide

You are creating a user name known as (plexguide) with sudo permissions!  

- Do Not Forget Your Password (If you do, use root to change)
- Recommend to login with user (plexguide) instead of root futurewise!
- This entire program (permisisons) RUNS from the user: plexguide

Version 4 Users: Create the user, and DO NOT ACCEPT THE UPGRADE. You can still 
use the old menu!

Encryption Note: If using encrypted method, DO NOT ACCEPT THE UPGRADE unless
your helping us test!  You can still use the old menu! 

EOF

#### (Not Used) read -p "Create a [USERNAME]: " username
read -p "Create a [PASSWORD] for [user - plexguide]: " password
printf "\n\n"

useradd -m -s /bin/bash plexguide -u 6000 -g 1000
echo -e ""$password"\n"$password"\n" | passwd plexguide
usermod -aG sudo plexguide
touch /var/plexguide/plexguide.user


cat << EOF

You created the user: plexguide

EOF

read -n 1 -s -r -p "Press any key to continue"

fi