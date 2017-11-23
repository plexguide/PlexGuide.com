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

1.  CouchPotato   | ** TESTING
2.  Emby          | ** TESTING
3.  Headphones    | ** TESTING
4.  Hydra         | ** TESTING
5.  NZBGET        | ** TESTING
6.  RuTorrent     | ** TESTING
7.  SickRage      | ** TESTING
8   Transmission  | ** TESTING
9.  NGINX-Proxy   | ** TESTING
10. DelugeVPN     | ** TESTING
11. PlexDrive     | ** DO NOT MESS WITH! SUPER BETA

EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 12 ];  Type [11] to Exit! " choice
	case $choice in
     1)
        echo ymlprogram couchpotato > /opt/plexguide/tmp.txt
        echo ymldisplay CouchPotato >> /opt/plexguide/tmp.txt
        echo ymlport 5050 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        ;;
      2)
      echo ymlprogram emby > /opt/plexguide/tmp.txt
      echo ymldisplay Emby >> /opt/plexguide/tmp.txt
      echo ymlport 8096 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;
      3)
    echo ymlprogram headphones > /opt/plexguide/tmp.txt
    echo ymldisplay Headphones >> /opt/plexguide/tmp.txt
    echo ymlport 8150 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
      4)
    echo ymlprogram hydra > /opt/plexguide/tmp.txt
    echo ymldisplay Hydra >> /opt/plexguide/tmp.txt
    echo ymlport 5075 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
   5)
    echo ymlprogram nzbget > /opt/plexguide/tmp.txt
    echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
    echo ymlport 6789 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  6)
    echo ymlprogram rutorrent > /opt/plexguide/tmp.txt
    echo ymldisplay RuTorrent >> /opt/plexguide/tmp.txt
    echo ymlport 8085 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  7)
    echo ymlprogram sickrage > /opt/plexguide/tmp.txt
    echo ymldisplay SickRage >> /opt/plexguide/tmp.txt
    echo ymlport 8081:8081 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  8)
    echo ymlprogram transmission > /opt/plexguide/tmp.txt
    echo ymldisplay Transmission >> /opt/plexguide/tmp.txt
    echo ymlport 9091 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  9)
    echo ymlprogram nginx-proxy> /opt/plexguide/tmp.txt
    echo ymldisplay nginx-proxy >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  10)
    clear
    bash /opt/plexguide/scripts/menus/delugevpn-menu.sh
    ;;
  11)
  echo ymlprogram PlexDrive> /opt/plexguide/tmp.txt
  echo ymldisplay PlexDrive >> /opt/plexguide/tmp.txt
  echo ymlport No Port >> /opt/plexguide/tmp.txt
  bash /opt/plexguide/scripts/docker-no/program-installer.sh
  12)
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
