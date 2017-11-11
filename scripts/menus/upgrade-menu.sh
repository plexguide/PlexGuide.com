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

Welcome to the PlexGuide.com > U-P-D-A-T-E Installer

1.  EMPTY
2.  Install: Sonarr
3.  Install: Radarr
4.  Install: SABNZBD
5.  EMPTY
6.  Upgrade: Ombi v3   
7.  Upgrade: Plex   
8.  Upgrade: Emby      
9.  Upgrade: PlexyPy 
10. Upgrade: NetData  
11. Upgrade: Muximux
12. Upgrade: Wordpress 
13. Upgrade: RuTorrent 
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
		clear
    ;;
  6)
    echo ymlprogram ombi > /opt/plexguide/tmp.txt
    echo ymldisplay Ombi >> /opt/plexguide/tmp.txt
    echo ymlport 3579 >> /opt/plexguide/tmp.txt
		bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
  7)
    echo ymlprogram plex > /opt/plexguide/tmp.txt
    echo ymldisplay Plex >> /opt/plexguide/tmp.txt
    echo ymlport 32400 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
  8)
    echo ymlprogram emby > /opt/plexguide/tmp.txt
    echo ymldisplay Emby >> /opt/plexguide/tmp.txt
    echo ymlport 8096 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
  9)
    echo ymlprogram plexpy > /opt/plexguide/tmp.txt
    echo ymldisplay PlexPY >> /opt/plexguide/tmp.txt
    echo ymlport 8181 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
	10)
    echo ymlprogram netdata > /opt/plexguide/tmp.txt
    echo ymldisplay NetData >> /opt/plexguide/tmp.txt
    echo ymlport 19999 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
  11)
    echo ymlprogram muximux > /opt/plexguide/tmp.txt
    echo ymldisplay Muximux >> /opt/plexguide/tmp.txt
    echo ymlport 8015 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
  12)
    echo ymlprogram wordpress > /opt/plexguide/tmp.txt
    echo ymldisplay WordPress >> /opt/plexguide/tmp.txt
    echo ymlport 80 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
  13)
    echo ymlprogram rutorrent > /opt/plexguide/tmp.txt
    echo ymldisplay RuTorrent >> /opt/plexguide/tmp.txt
    echo ymlport 8085 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker/upgrade-programs.sh
    ;;
	14) 
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
