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

#check to see if /var/plexguide/dep exists - if not, install dependencies

file="/var/plexguide/dep.yes"
if [ -e "$file" ]
then
    clear
else
    bash /opt/plexguide/scripts/docker-no/dep.sh
fi

# function to display menus
show_menus() {
clear
cat << EOF
Welcome PlexGuide.com Installer 3.5 - 11 Nov

Using Google Drive? Part 1 and 2 are required.
Written By: Admin9705 & Deiteq at Github (PlexGuide.com)

~~~~~~~~~~~~~~~~~~~~~
  M A I N - M E N U
~~~~~~~~~~~~~~~~~~~~~
1. Google Drive Only: PlexDrive4 & (RClone << * Not Ready *)
2. Install & Upgrade: Individual Program 
3. PlexGuide Program: Upgrade this Program
4. Secure the Server: * Not Ready *
5. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 5 ] " choice
	case $choice in
	1)
	    bash /opt/plexguide/scripts/menus/plexmenu.sh
	    ;;
	2)
        bash /opt/plexguide/scripts/menus/programs.sh
        clear
        ;;
	3)
        bash /opt/plexguide/scripts/docker-no/upgrade.sh
        clear
        echo Remember, restart by typing:  plexguide
        exit 0;;
    4)
        clear
        echo "*** This Area is Not Ready ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
    5)
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
