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

file="/var/plexguide/dep12.yes"
if [ -e "$file" ]
then
    clear
else
    bash /opt/plexguide/scripts/startup/dep.sh
    touch /var/plexguide/dep12.yes
fi


# function to display menus
show_menus() {
clear
cat << EOF
PlexGuide.com Installer V4 (17.12.02) | Written By: Admin9705 & Deiteq
ASSIST US: Visit http://wiki.plexguide.com - Update & Edit the Wiki

DONATION ASSISTANCE INFORMATION *************************************
>>> Visit http://hexabot.us to Compound Weekly on Bit & Lite Coins! <<<
>>> Buy coins to Start investing at http://coin.plexguide.com <<<

GOOGLE DRIVE ********************************************************
1. RClone   :  Media Syncs to Google Drive
2. PlexDrive:  Prevent G-Drive Plex Scan Bans

PROGRAMS ************************************************************
3. Programs :  Install Plex, Couch, NetData, Radarr, Sonarr & More!
4. BETA BETA:  Install Working Beta Programs! No Guides, YMLs Work!

TOOLS & T-SHOOT *****************************************************
5. Updates  :  Update PlexGuide for New Features & Fixes
6. Tools    :  Troubleshoot Problems & Provides Helpful Information
7. Backup   :  NOT FUNCTIONAL YET - Backup Program Data
8. Restore  :  NOT FUNCTIONAL YET - Restore Program Data

EOF

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 ];  Type [9] to Exit! " choice
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
        bash /opt/plexguide/scripts/menus/programs-beta.sh
        clear
        ;;
    5)
        bash /opt/plexguide/scripts/docker-no/upgrade.sh
        clear
        echo Remember, restart by typing: plexguide
        exit 0;;
    6)
        bash /opt/plexguide/scripts/menus/trouble-menu.sh
        clear
        ;;
    9)
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
