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
Welcome PlexGuide.com Installer 3.5 - 9 Nov

Using Google Drive? Part 1 and 2 are required.
Written By: Admin9705 & Deiteq at Github (PlexGuide.com)

~~~~~~~~~~~~~~~~~~~~~
  M A I N - M E N U
~~~~~~~~~~~~~~~~~~~~~
1. Install: For Google Drive - PlexDrive 4
2. Install: For Google Drive - RClone       * Not Ready *
3. Install: Individual Programs
4. Update : Individual Programs             * Not Ready *
5. Update : PlexGuide Program
6. New CPU: Mass Program Install
7. Secure : Lock Down & Secure the Server   * Not Ready *
8. Exit

EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 ] " choice
	case $choice in
		1)
		    bash /opt/plexguide/scripts/plexmenu.sh
		
		    ;;
		2)
    clear
    echo "*** This Area is Not Ready - Use @ Your Own Risk ***"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    clear
        cd /opt/plexguide/scripts/
        bash rclone-menu.sh
        ;;
		3)
        cd /opt/plexguide/scripts/
        bash dep2.sh
        bash individual-menu.sh
        ;;
		4)
    clear
    echo "*** This Area is Not Ready ***"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    clear
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
        cd /opt/plexguide/scripts/
        bash mass.sh
    		;;
     7)
        clear
        echo "*** This Area is Not Ready ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
    8)
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
