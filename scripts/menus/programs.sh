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
PlexGuide.com Installer/Upgrader (**No Guide Yet)

1.  Plex          | Sharing media program - * The Reason We Are Here *
2.  CouchPotato   | ** Movie requesting program; older program
3.  Emby          | ** Alternative to PLEX and less restrictive
4.  Headphones    | ** Music requesting program
5.  Hydra         | ** Meta search for NZB indexers
6.  NetData       | Statistical Tool for the Server
7.  Muximux       | ** Site Interface to control your programs
8.  NZBGET        | ** USENET Downloading Program
9.  Ombi v3       | ** Enables users to request media
10. Organizr      | ** Site Interface to control your programs
11. PlexPy        | Provides analytics about your PLEX Users
12. Portainer     | Manage your Docker Containers | Installed By Default
13. Radarr        | Movie requesting program; newer less mature program
14. RuTorrent     | ** Torrent Downloading Program
15. SABNZBD       | USENET Downloading Program
16. SickRage      | ** TV Show requesting program
17. Sonarr        | TV Show requesting program (Recommended)
18. Transmission  | ** Torrent Downloading Program
19. Wordpress     | Create a website for users to interact
20. NGINX-Proxy   | ** TESTING
21. DelugeVPN     | ** TESTING
22. Exit

EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 21 ] " choice
	case $choice in
  1)
  clear
  bash /opt/plexguide/scripts/menus/plexsub-menu.sh
  ;;
  2)
    echo ymlprogram couchpotato > /opt/plexguide/tmp.txt
    echo ymldisplay CouchPotato >> /opt/plexguide/tmp.txt
    echo ymlport 5050 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  3)
    echo ymlprogram emby > /opt/plexguide/tmp.txt
    echo ymldisplay Emby >> /opt/plexguide/tmp.txt
    echo ymlport 8096 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  4)
    echo ymlprogram headphones > /opt/plexguide/tmp.txt
    echo ymldisplay Headphones >> /opt/plexguide/tmp.txt
    echo ymlport 8150 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
   5)
    echo ymlprogram hydra > /opt/plexguide/tmp.txt
    echo ymldisplay Hydra >> /opt/plexguide/tmp.txt
    echo ymlport 5075 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
   6)
    echo ymlprogram netdata > /opt/plexguide/tmp.txt
    echo ymldisplay NetData >> /opt/plexguide/tmp.txt
    echo ymlport 19999 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
   7)
    echo ymlprogram muximux > /opt/plexguide/tmp.txt
    echo ymldisplay Muximux >> /opt/plexguide/tmp.txt
    echo ymlport 8015 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
   8)
    echo ymlprogram nzbget > /opt/plexguide/tmp.txt
    echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
    echo ymlport 6789 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
   9)
    echo ymlprogram ombi > /opt/plexguide/tmp.txt
    echo ymldisplay Ombi >> /opt/plexguide/tmp.txt
    echo ymlport 3579 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  10)
    echo ymlprogram organizr > /opt/plexguide/tmp.txt
    echo ymldisplay Organizr >> /opt/plexguide/tmp.txt
    echo ymlport 8020 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  11)
    echo ymlprogram plexpy > /opt/plexguide/tmp.txt
    echo ymldisplay PlexPY >> /opt/plexguide/tmp.txt
    echo ymlport 8181 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  12)
    echo ymlprogram portainer > /opt/plexguide/tmp.txt
    echo ymldisplay Portainer >> /opt/plexguide/tmp.txt
    echo ymlport 9000 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  13)
    echo ymlprogram radarr > /opt/plexguide/tmp.txt
    echo ymldisplay Radarr >> /opt/plexguide/tmp.txt
    echo ymlport 7878 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  14)
    echo ymlprogram rutorrent > /opt/plexguide/tmp.txt
    echo ymldisplay RuTorrent >> /opt/plexguide/tmp.txt
    echo ymlport 8085 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  15)
    echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
    echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
    echo ymlport 8090 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  16)
    echo ymlprogram sickrage > /opt/plexguide/tmp.txt
    echo ymldisplay SickRage >> /opt/plexguide/tmp.txt
    echo ymlport 8081:8081 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  17)
    echo ymlprogram sonarr > /opt/plexguide/tmp.txt
    echo ymldisplay Sonarr >> /opt/plexguide/tmp.txt
    echo ymlport 8989 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  18)
    echo ymlprogram transmission > /opt/plexguide/tmp.txt
    echo ymldisplay Transmission >> /opt/plexguide/tmp.txt
    echo ymlport 9091 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  19)
    echo ymlprogram wordpress > /opt/plexguide/tmp.txt
    echo ymldisplay WordPress >> /opt/plexguide/tmp.txt
    echo ymlport 80 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  20)
    echo ymlprogram nginx-proxy> /opt/plexguide/tmp.txt
    echo ymldisplay nginx-proxy >> /opt/plexguide/tmp.txt
    echo ymlport 80 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  21)
    echo ymlprogram delugevpn > /opt/plexguide/tmp.txt
    echo ymldisplay DelugeVPN >> /opt/plexguide/tmp.txt
    echo ymlport 8112 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  22)
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
