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
PlexGuide.com BETA Installer ~ BETA ~ BETA ~ BETA ~ BETA ~ BETA
Warning: NO SUPPORT! QUESTIONS WILL BE IGNORED!

1.  Headphones    | ** TESTING
2.  Hydra         | ** TESTING
3.  RuTorrent     | ** TESTING
4   Transmission  | ** TESTING
5.  DelugeVPN     | ** TESTING
6.  Jackett       | ** TESTING
7.  LetsEncrypt   | ** TESTIGN

EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 8 ];  Type [8] to Exit! " choice
	case $choice in
  1)
    echo ymlprogram emby > /opt/plexguide/tmp.txt
    echo ymldisplay Emby >> /opt/plexguide/tmp.txt
    echo ymlport 8096 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  2)
    echo ymlprogram headphones > /opt/plexguide/tmp.txt
    echo ymldisplay Headphones >> /opt/plexguide/tmp.txt
    echo ymlport 8150 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
  3)
    echo ymlprogram hydra > /opt/plexguide/tmp.txt
    echo ymldisplay Hydra >> /opt/plexguide/tmp.txt
    echo ymlport 5075 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  4)
    echo ymlprogram transmission > /opt/plexguide/tmp.txt
    echo ymldisplay Transmission >> /opt/plexguide/tmp.txt
    echo ymlport 9091 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  5)
    clear
    bash /opt/plexguide/scripts/menus/delugevpn-menu.sh
    ;;
  6)
    echo ymlprogram jackett > /opt/plexguide/tmp.txt
    echo ymldisplay Jackett >> /opt/plexguide/tmp.txt
    echo ymlport 9117 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  7)
    echo ymlprogram letsencrypt > /opt/plexguide/tmp.txt
    echo ymldisplay Lets Encrypt >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  8)
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
