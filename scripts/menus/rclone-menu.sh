#!/bin/bash
# Main Menu for PlexGuide
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
Note: Only Install one version of RClone; encrypted or unencrypted. If you
switch; you can. I mitgated everything but reboot if making a switch.


RCLONE INSTALLERS *****************************************************
1. Unencrypted Install  :  Utilize the unencrypted version of RClone
2. Encrypted Install    :  Utilize the encrypted version of RClone

Please visit http://wiki.plexguide.com for any tutorial information. It is
recommended to view the following guides to save YOU SOME GRIEF!!!

	*** GoogleAPI        - http://googleapi.plexguide.com
	*** Unencrypt RClone - http://unrclone.plexguide.com
	*** Encrypted RClone - http://enrclone.plexguide.com
 
 
EOF

}

read_options(){
	local choice
	read -p "Enter Choice [ 1 - 3];  Type [3] to Exit! " choice
	case $choice in
	1)
		bash /opt/plexguide/scripts/docker-no/rclone-un.sh
		;;
	2)
		bash /opt/plexguide/scripts/docker-no/rclone-en.sh
  		;;
	3)
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
