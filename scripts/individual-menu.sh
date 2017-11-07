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

# function to display menus
show_menus() {
clear
cat << EOF

Welcome to the PlexGuide.com > I-N-D-I-V-I-D-U-A-L Installer

1.  Install: Plex
2.  Install: SSH
3.  Install: Sonarr
4.  Install: Radarr
5.  Install: SABNZBD
6.  Install: DOCKER & Portainer
7   Docker : Ombi v3   (Requires Docker)
8.  Docker : Emby      (Requires Docker)
9.  Docker : PlexyPy   (Requires Docker)
10. Docker : NetData   (Requires Docker)
11. Docker : Muximux   (Requires Docker)
12. Docker : Wordpress (Requires Docker)
13. Docker : RuTorrent (Requires Docker) [Works, but doesn't download - Help]
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
           bash plex.sh
           bash continue.sh
       ;;
        2)
		   bash ssh.sh
		   bash continue.sh
       ;;
        3)
		   bash sonarr.sh
		   bash continue.sh
       ;;
        4)
		   bash radarr.sh
		   bash continue.sh
       ;;
        5)
           bash sabnzbd.sh
		   bash continue.sh
       ;;
        6)
		   bash docker.sh
		   bash continue.sh
       ;;
        7)
		   bash ombi.sh
		   bash continue.sh
       ;;
        8)
		   bash emby.sh
		   bash continue.sh
       ;;
        9)
		   bash plexpy.sh
		   bash continue.sh
       ;;
		   10)
		   bash netdata.sh
		   bash continue.sh
       ;;
        11)
		   bash muximux.sh
		   bash continue.sh
       ;;
        12)
		   bash wordpress.sh
		   bash continue.sh
       ;;
       13)
     bash rutorrent.sh
     bash continue.sh
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
