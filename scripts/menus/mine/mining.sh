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
echo "Your IP Address: " | hostname -I
cat << EOF
Helping mining coins with a small amount of CPU helps out.  By default, 
this is off.  To see how it impacts your server, install NETDATA and
visit http://ipv4:19999!  Thanks for dropping by!

GOOGLE DRIVE ******************************************************
1. Allow the use of 1 CPUs
2. Allow the use of 2 CPUs
3. Allow the use of 4 CPUs
4. Allow the use of 8 CPUs
5. Max It Out (Only select if your sure about this)

TURN OFF ************************************************************
6. Programs :  Install Plex, Couch, NetData, Radarr, Sonarr & More!

EOF

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 ];  Type [7] to Exit! " choice
	case $choice in
	1)
        clear
	      bash /opt/plexguide/scripts/menus/mine/1.sh
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
        ;;
    6)
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
