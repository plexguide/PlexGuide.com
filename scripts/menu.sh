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

if [ "$(id -u)" != "6000" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#check to see if /var/plexguide/dep exists - if not, install dependencies
bash /opt/plexguide/scripts/docker-no/user.sh

file="/var/plexguide/dep17.yes"
if [ -e "$file" ]
then
    clear
else
    bash /opt/plexguide/scripts/startup/dep.sh
    touch /var/plexguide/dep17.yes
fi

##clear screen
clear

show_menus() {
cat << EOF
PlexGuide.com Installer V5 (17.12.11) | Written By: Admin9705 & Deiteq
Visit http://wiki.plexguide.com <<< You can edit and improve the Wiki!

DONATION *********************************************************
1. Mining   :  Enable a little CPU to Mine Coins (It Helps Us)

GOOGLE DRIVE *********************************************************
2. RClone   :  Media Syncs to Google Drive
3. PlexDrive:  Prevent G-Drive Plex Scan Bans

PROGRAMS *************************************************************
4. Programs :  Install Plex, Couch, NetData, Radarr, Sonarr & More!
5. Updates  :  Update PlexGuide for the newest features & bugfixes!

INFO & T-SHOOT *******************************************************
6. Info View:  View System Information to Assist You
7. T-Shoot  :  Troubleshoot Problems & Provides Helpful Information

SYSTEM BACKUP & RESTORE - RCLONE MUST BE SETUP ***********************
8. Backup   :  Backup Docker Program Data to Your Google Drive
9. Restore  :  Restore Program Data From Your Google Drive

EOF

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 10 ];  Type [10] to Exit! " choice
	case $choice in
    1)
        clear
            file="/var/plexguide/miner.set"
            if [ -e "$file" ]
            then
                clear
            else
                touch /var/plexguide/miner.set
                echo "Conducting Pre-Stage & Checks (Please Wait)"
                wget https://minergate.com/download/deb-cli -O minergate-cli.deb 1>/dev/null 2>&1
                yes | dpkg -i minergate-cli.deb 1>/dev/null 2>&1
                clear
            fi
          bash /opt/plexguide/scripts/menus/mine/mining.sh
        ;;
	2)
        clear
	      bash /opt/plexguide/scripts/menus/rclone-menu.sh
        ;;
    3)
        clear
        bash /opt/plexguide/scripts/menus/plexdrive-menu.sh
        ;;
	4)
        bash /opt/plexguide/scripts/menus/programs.sh
        clear
        ;;
    5)
        bash /opt/plexguide/scripts/docker-no/upgrade.sh
        clear
        echo Remember, restart by typing: plexguide
        exit 0;;
    6)
        bash /opt/plexguide/scripts/menus/info-menu.sh
        clear
        ;;
    7)
        bash /opt/plexguide/scripts/menus/trouble-menu.sh
        clear
        ;;
    8)
        bash /opt/plexguide/scripts/menus/backup-menu.sh
        clear
        ;;
    9)
        bash /opt/plexguide/scripts/menus/restore-menu.sh
        clear
        ;;
    99)
        bash /opt/plexguide/scripts/menus/programs-beta.sh
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
