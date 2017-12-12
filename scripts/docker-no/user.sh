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

ENCRYPTION USERS WARNING! If using encrypted method, do not upgrade. Create the
user as required, but when asking for upgrade; select NO. Encryption needs work!

EOF

#### (Not Used) read -p "Create a [USERNAME]: " username
read -p "Create a [PASSWORD] for [user - plexguide]: " password
printf "\n\n"

useradd -m -s /bin/bash plexguide -u 6000 -g 1000
echo -e ""$password"\n"$password"\n" | passwd plexguide
usermod -aG sudo plexguide
touch /var/plexguide/plexguide.user

clear

cat << EOF
********* READ READ READ *********
You Created the user: plexguide

In the future, run as the user (plexguide)
1. su plexguide << change to user plexguide
2. plexguide << start the program

EOF
read -n 1 -s -r -p "Press any key to continue"

exit
fi
