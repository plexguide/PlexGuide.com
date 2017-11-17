#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
	echo "one() called"
        pause
}

# do something in two()
two(){
	echo "two() called"
        pause
}

# function to display menus
show_menus() {

clear
cat << EOF
~~~~~~~~~~~~~~~~~~~~~~~~
   PLEXDRIVE TUTORIAL
~~~~~~~~~~~~~~~~~~~~~~~~

Please visit http://wiki.plexguide.com for any tutorial information.  It is
recommended to view the following guides:

*** GoogleAPI  - http://googleapi.plexguide.com
*** PlexDrive4 - http://plexdrive.plexguide.com

Note, you nedd your Google API Keys.  Forgetting to do so will cause some grief.

1. View Obtain Google API Guide
2. View PlexDrive Install Guide
3. Proceed onward to the PlexDrive Install
4. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
		1)
    clear
    cat << EOF
Google API Guide (Page 1 of 1)
http://googleapi.plexguid.com  | WARNING: Write this down and follow the order

* Select project or create a new project
* Under Overview, Google APs, Google Apps APIs; click "Drive API", then enable
* Click "Credentails" in the left-side panel
  (not "Go to Credentials" which is a Wizard)
* Then "Create credenntials"
* Then "OAuth client ID"
* Prompted to set OAuth consent screen product name.
* Choose application type as "other" and then click "Create"
* If you DO NOT SELECT other, the API is useless and will not work
* Will then show you a client ID and client secret
* Keep this somewhere secure; you need it for RClone and PlexDrive

EOF
    bash /opt/plexguide/scripts/docker-no/continue.sh

# Final Note
        cat << EOF
Google API Install
http://googleapi.plexguide.com

You can visit this area again.  Visiting the website is highly encouraged!

EOF
    bash /opt/plexguide/scripts/docker-no/continue.sh
      ;;
		2)
# PlexDrive4
    cat << EOF
- Ensure that you obtained your Google API Secret & Password
  http://googleapi.plexguide.com
- Ensure that you do not let this program close or shutdown until finished
- You can open another terminal window; do not close this one
- Goto http://plexdrive.plexguide.com to how it looks when completed

WINDOWS USERS Only: When copying information to your terminal winodw,
PRESS [CTRL+Insert].  Do not use CTRL+C; this will result in messing up
things.  This then will require you to DELETE your PLEXDRIVE tokens and
restart the process again.

ALL USERS: Anytime you mess things up or have problems, press CTRL + Z or X
to break out.  Come back again, select Option 3 to remove previous keys and
press option [1] to restart the process.

EOF
    read -n 1 -s -r -p "Press any key to continue"
    clear

# Final Note
    cat << EOF

PlexDrive 4 Install
http://plexdrive.plexguide.com

You can visit this area again.  Visiting the website is highly encouraged!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh
      ;;
    3)
bash /opt/plexguide/scripts/menus/rclone-menu.sh
      ;;
    4)
      exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do

	show_menus
	read_options
done
