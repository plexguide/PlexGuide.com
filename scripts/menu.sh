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
	echo "Welcome to the PlexGuide.com Installer v3.5 - 5 NOV III"
	echo
	echo "Note: It will always prompt you for installs on each program"
	echo 
	echo "Google Drive Only: If you are mounting your google drive,"
	echo "you must install part 1 first (plexdrive4). http://plexdrive.plexguide.com"
	echo
	echo "Non-Google Drive setup, skip part 1"
    echo	
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install: PlexDrive 4"
	echo "2. Install: RClone (Not Operational Yet)"
	echo "3. Install: New Server Setup"
	echo "4. Install: Programs Individually"
	echo "5. Update : PlexGuide Program"
	echo "6. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 6 ] " choice
	case $choice in
		1)
		cd /opt/plexguide/scripts/
		bash plexmenu.sh
		;;
		2)
        cd /opt/plexguide/scripts/
        bash rclone-menu.sh
        ;;
		3)
        cd /opt/plexguide/scripts/
        bash mass.sh
        ;;
		4) 
        cd /opt/plexguide/scripts/
		bash dep2.sh
		bash individual-menu.sh
		;;
		5) 
        cd /opt/plexguide/scripts/
        bash upgrade.sh
        clear
        echo You are required to restart the program. 
        echo Restart the program afterwards by typing:  plexguide
        echo 
        read -n 1 -s -r -p "Press any key to continue "
        clear
        echo Remember, restart by typing:  plexguide
        exit 0;;
        6)
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


            
