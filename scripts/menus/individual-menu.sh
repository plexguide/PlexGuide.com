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

#set path for docker items
VARMENU1="/opt/plexguide/scripts/docker/"

#set path for non-docker items
VARMENU2="/opt/plexguide/scripts/docker-no/"

# function to display menus
show_menus() {
clear

cat << EOF

Welcome to the PlexGuide.com > I-N-D-I-V-I-D-U-A-L Installer

1.  EMPTY
2.  Install: Sonarr
3.  Install: Radarr
4.  Install: SABNZBD
5.  EMPTY
6.  Docker : Ombi v3
7.  Docker : Plex   
8.  Docker : Emby    
9.  Docker : PlexyPy
10. Docker : NetData 
11. Docker : Muximux  
12. Docker : Wordpress
13. Docker : RuTorrent
14. Exit
EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 14 ] " choice
	case $choice in
        1)
		   clear
       ;;
        2)
		   bash "$VARMENU2"sonarr.sh
		   bash "$VARMENU2"continue.sh
       ;;
        3)
		   bash "$VARMENU2"radarr.sh
		   bash "$VARMENU2"continue.sh
       ;;
        4)
           bash "$VARMENU2"sabnzbd.sh
		   bash "$VARMENU2"continue.sh
       ;;
        5)
		   bash "$VARMENU1"docker.sh
		   bash "$VARMENU1"continue.sh
       ;;
        6)
		   bash "$VARMENU1"ombi.sh
		   bash "$VARMENU1"continue.sh
       ;;
        7)
		   bash "$VARMENU1"plex.sh
		   bash "$VARMENU1"continue.sh
       ;;
        8)
		   bash "$VARMENU1"emby.sh
		   bash "$VARMENU1"continue.sh
       ;;
        9)
		   bash "$VARMENU1"plexpy.sh
		   bash "$VARMENU1"continue.sh
       ;;
		   10)
		   bash "$VARMENU1"netdata.sh
		   bash "$VARMENU1"continue.sh
       ;;
        11)
		   bash "$VARMENU1"muximux.sh
		   bash "$VARMENU1"continue.sh
       ;;
        12)
		   bash "$VARMENU1"wordpress.sh
		   bash "$VARMENU1"continue.sh
       ;;
       13)
     	   bash "$VARMENU1"rutorrent.sh
           bash "$VARMENU1"continue.sh
      ;;
		14) exit 0;;
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
