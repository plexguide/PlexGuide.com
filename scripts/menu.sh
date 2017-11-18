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

file="/var/plexguide/dep6.yes"
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
Welcome PlexGuide.com Installer V4 - Version Nov 19
Written By: Admin9705 & Deiteq at Github (PlexGuide.com)

Plans : Security, NGINX, VPNs, Custom Ports
Social: (Slack - plexguide.slack.com) or (Reddit - plexguide.reddit.com)

~~~~~~~~~~~~~~~~~~~~~
  M A I N - M E N U
~~~~~~~~~~~~~~~~~~~~~
1. Install - RClone   :  Media Syncs to Google Drive
2. Install - PlexDrive:  Prevent G-Drive Plex Scan Bans
3. Install & Update   :  Server Programs & Tools
4. Update PlexGuide   :  Upgrade this Program (Newest Updates & Fixes)
5. Troubleshooting 101:  Hope this helps!
                         ----------------------------------------------
6. Donate By Mining   :  (READ) Can donate a little processing power :D
7. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 ] " choice
	case $choice in
	1)
        clear
	      bash /opt/plexguide/scripts/menus/rclone-info-menu.sh
        ;;
  2)
        clear
        bash /opt/plexguide/scripts/menus/plexdrive-info-menu.sh
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
        bash /opt/plexguide/scripts/menus/trouble-menu.sh
        clear
        ;;
  6)    bash /opt/plexguide/scripts/menus/mine-menu.sh
        clear
        ;;
  7)
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
