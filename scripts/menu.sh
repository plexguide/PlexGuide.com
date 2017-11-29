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

file="/var/plexguide/dep11.yes"
if [ -e "$file" ]
then
    clear
else
    bash /opt/plexguide/scripts/startup/dep.sh
    touch /var/plexguide/dep11.yes
fi


# function to display menus
show_menus() {
clear
cat << EOF
PlexGuide.com Installer V4 (17.11.29) | Written By: Admin9705 & Deiteq
ASSIST US: Visit http://wiki.plexguide.com - Update & Edit the Wiki

DONATION ASSISTANCE INFORMATION *************************************
1. Donate   :  Help Us Utilize a little CPU to Mine Coins
>>> Visit http://hexabot.us to compound 20% Weekly on Your Coins! <<<

GOOGLE DRIVE ********************************************************
2. RClone   :  Media Syncs to Google Drive
3. PlexDrive:  Prevent G-Drive Plex Scan Bans

PROGRAMS ************************************************************
4. Programs :  Install Plex, Couch, NetData, Radarr, Sonarr & More!
5. BETA BETA:  Install Working Beta Programs! No Guides, YMLs Work!

TOOLS & T-SHOOT *****************************************************
6. Updates  :  Update PlexGuide for New Features & Fixes
7. Tools    :  Troubleshoot Problems & Provides Helpful Information
8. Backup   :  NOT FUNCTIONAL YET - Backup Program Data
9. Restore  :  NOT FUNCTIONAL YET - Restore Program Data

EOF

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 10 ];  Type [10] to Exit! " choice
	case $choice in
    1)
        bash /opt/plexguide/scripts/menus/mine/mining.sh
        clear
        ;;
	2)
        clear
	      bash /opt/plexguide/scripts/menus/rclone-info-menu.sh
        ;;
    3)
        clear
        bash /opt/plexguide/scripts/menus/plexdrive-info-menu.sh
        ;;
	4)
        bash /opt/plexguide/scripts/menus/programs.sh
        clear
        ;;
    5)
        bash /opt/plexguide/scripts/menus/programs-beta.sh
        clear
        ;;
    6)
        bash /opt/plexguide/scripts/docker-no/upgrade.sh
        clear
        echo Remember, restart by typing: plexguide
        exit 0;;
    7)
        bash /opt/plexguide/scripts/menus/trouble-menu.sh
        clear
        ;;
    10)
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
