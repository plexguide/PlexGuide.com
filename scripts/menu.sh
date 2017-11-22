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

file="/var/plexguide/dep8.yes"
if [ -e "$file" ]
then
    clear
else
    bash /opt/plexguide/scripts/docker-no/dep.sh
fi


# function to display menus
show_menus() {
clear
echo "Your IP Address: " hostname -I | hostname -I | awk '{print $1}'
cat << EOF
PlexGuide.com Installer V4 (17.11.22) | Written By: Admin9705 & Deiteq
ASSIST US: Visit http://wiki.plexguide.com - Update & Edit our Wiki

GOOGLE DRIVE ******************************************************
1. RClone   :  Media Syncs to Google Drive
2. PlexDrive:  Prevent G-Drive Plex Scan Bans

SERVER ************************************************************
3. Programs :  Install Plex, Couch, NetData, Radarr, Sonarr & More!
4. Tools    :  Troubleshoot Problems & Provides Helpful Information
5. Updates  :  Update PlexGuide for New Features & Fixes
6. Backup   :  NOT FUNCTIONAL YET - Backup Program Data
7. Restore  :  NOT FUNCTIONAL YET - Restore Program Data

DONATE (Off By Default - You can turn this off or on anytime) *****
8. Donate   :  NOT FUNCTIONAL - Utilize a little CPU to mine coins.


EOF

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 ];  Type [9] to Exit! " choice
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
        bash /opt/plexguide/scripts/menus/trouble-menu.sh
        clear
        ;;
  5)
        bash /opt/plexguide/scripts/docker-no/upgrade.sh
        clear
        echo Remember, restart by typing: plexguide
        exit 0;;
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
