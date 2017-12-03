#!/bin/bash
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# Step #2: User defined function#
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
PlexGuide.com Backup - BETA PHASE - Do NOT USE

1. OMBIv3
2. NZBGET
2. SABNZBD

EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 3 ];  Type [3] to Exit! " choice
	case $choice in
     1)
      echo ymlprogram ombiv3 > /opt/plexguide/tmp.txt
      echo ymldisplay OMBIV3 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
     ;;
     2)
      echo ymlprogram nzbget > /opt/plexguide/tmp.txt
      echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;
     3)
      echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;
     4)
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
