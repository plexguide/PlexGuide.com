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
~~~~~~~~~~~~~~~~~~~~~~~
    RCLONE WARNING
~~~~~~~~~~~~~~~~~~~~~~~

Please visit http://wiki.plexguide.com for any tutorial information.  It is
recommended to view the following guides:

*** GoogleAPI        - http://googleapi.plexguide.com
*** Unencrypt RClone - http://unrclone.plexguide.com
*** Encrypted RClone - http://enrclone.plexguide.com

Not reading or following the guides will cause you some grief!

1. I read and/or bookmarked the guides! Let me Install RClone!
2. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 2 ] " choice
	case $choice in
    1)
bash /opt/plexguide/scripts/menus/rclone-menu.sh
      ;;
    2)
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
