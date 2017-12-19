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
~~~~~~~~~~~~~~~~~~
  SABNZBD SELECT
~~~~~~~~~~~~~~~~~~

Note: You can change back and forth between the two anytime.

1. Install Latest SABNZBD (Stable Release)
2. Install Latest SABNZBD (Beta Release)
3. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3 ] " choice
	case $choice in
		1)
      docker rm sabnzbd-beta
      docker rm sabnzbd
      clear
      echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
      echo ymlport 8090 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;
		2)
      docker rm sabnzbd
      docker rm sabnzbd-beta
      clear
      echo ymlprogram sabnzbd-beta > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD Beta >> /opt/plexguide/tmp.txt
      echo ymlport 8090 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;
    3)
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
