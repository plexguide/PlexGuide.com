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
	echo "Note: Enable PlexDrive Service AFTER PlexDrive Installs"
	echo "If you do this before or after, you may have problems"
	echo "with PlexDrive eveytime that you reboot"
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " P-L-E-X-D-R-I-V-E-4"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install PlexDrive"
	echo "2. Enable PlexDrive Service"
	echo "3. Delete Current PlexDrive Tokens (Not Working)"
	echo "4. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 4] " choice
	case $choice in
		1)
		cd /opt/plexguide/scripts/
		bash plexdrive4.sh
		;;
		2)
        cd /opt/plexguide/scripts/plexdrive-service-move.sh
        echo
        echo "Does Nothing Yet"
        ;;
		3) 
        cd /opt/plexguide/scripts/
        echo "Does Nothing Yet"
        echo
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


            
