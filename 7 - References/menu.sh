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
	echo Welcome to the Awesome Plex Server - PlexGuide.com
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " I-N-D-I-V-I-D-U-A-L"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install: Plex"
	echo "2. Install: NetData"
	echo "3. Install: SSH"
	echo "4. Install: Ombi v3 (Beta)"
	echo "5. Install: Sonarr"
	echo "6. Install: Docker | PlexPy | Mumimux | Portainer"
	echo "7. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 ] " choice
	case $choice in
		1) 
                   bash plex.sh
       ;;
		2) 
		   bash netdata.sh
       ;;
                3) 
		   bash ssh.sh
       ;;
                4)
		   bash ombi.sh
       ;;
                5)
		   bash sonarr.sh	   
       ;;
                6)
		   bash docker.sh
       ;;
		7) exit 0;;
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
