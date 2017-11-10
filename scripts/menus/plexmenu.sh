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
    echo "If you are having errors, bad pages, or didn't let the"
    echo "install finish, but cannot get it to start; select option #3"
    echo "This will allow you to run Option [1] again"
    echo
    echo "I highly recommend you check on http://plexdrive.plexguide.com"
    echo "before starting the entire process"
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " P-L-E-X-D-R-I-V-E-4"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install PlexDrive"
	echo "2. Service: Start/Restart PlexDrive Service"
	echo "3. Delete Current PlexDrive Tokens"
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
