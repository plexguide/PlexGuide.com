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
PLEASE READ the PlexDrive Section @ http://wiki.plexguide.com
Have the Google Tokens ready! @ http://plexdrive.plexguide.com

WARNING Windows Users!

Having issues because you did not follow directions or mistyped?
Please check your PlexDrive4 Status, Restart and if your still 
having issues, please delete your CURRENT TOKENS and start again!

~~~~~~~~~~~~~~~~~~~~~~~~	
  PLEXDRIVE4 Installer
~~~~~~~~~~~~~~~~~~~~~~~~
1. Install PlexDrive:  Read Instructions Prior
2. Troubleshooting  :  Restart PlexDrive4 Status
3. Troubleshooting  :  Delete PlexDrive4 Tokens
4. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 4] " choice
	case $choice in
		1)
		    bash /opt/scripts/docker-no/plexdrive4.sh
		    ;;
		2)
        	systemctl restart plexdrive4
       		echo
        	echo "PlexDrive4 Service started/restarted"
       	    echo
        	read -n 1 -s -r -p "Press any key to continue"
        	;;
		3)
       		rm -r /root/.plexdrive
        	echo
        	echo "Tokens Removed"
        	echo
        	read -n 1 -s -r -p "Press any key to continue"
        	clear
		    ;;
        4)
        	clear
        	echo Remember, restart by typing:  plexguide
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
