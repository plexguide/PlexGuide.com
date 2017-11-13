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

file="/var/plexguide/dep3.yes"
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
Welcome PlexGuide.com Installer V4 - Nov 12 II
Written By: Admin9705 & Deiteq at Github (PlexGuide.com)

Unlimited Storage comes from Google G-Suite, 10 (US Dollars) a Month.
Please READ the Wiki at http://wiki.plexguide.com (It will help you!)
Please feel free to contribute to this project or wiki!

Plans: Security, NGINX, VPNs, Custom Ports
Focus: Bugs - Please Report!

~~~~~~~~~~~~~~~~~~~~~
  M A I N - M E N U
~~~~~~~~~~~~~~~~~~~~~
1. RClone Install    :  Media Syncs to Google Drive
2. PlexDrive4 Install:  Prevent G-Drive Plex Scan Bans
3. Install & Upgrade :  Server Programs & Tools
4. PlexGuide Program :  Upgrade This Program
5. Secure the Server :  * Not Ready *
6. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 6 ] " choice
	case $choice in
	1)
        clear
	    bash /opt/plexguide/scripts/menus/rclone-menu.sh
	    ;;
    2)
        clear
        bash /opt/plexguide/scripts/menus/plexdrive-menu.sh
        ;;
	3)
        bash /opt/plexguide/scripts/menus/programs.sh
        clear
        ;;
	4)
        bash /opt/plexguide/scripts/docker-no/upgrade.sh
        clear
        echo Remember, restart by typing: plexguide
        exit 0;;
    5)
        clear
        echo "*** This Area is Not Ready ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
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
