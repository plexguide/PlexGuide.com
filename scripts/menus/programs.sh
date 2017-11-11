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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 PlexGuide.com Installer/Upgrader
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  Sonarr        | TV Show requeseting program; more organized
2.  SABNZBD       | USENET Downloading Program
3.  Radarr        | Movie requesting program; newer less mature program
4.  CouchPotato   | Movie requesting program; older outdated program
5.  Organizr      | Self-managed site interface to control your programs
6.  Ombi v3       | Enables users to request media 
7.  Plex          | Sharing media program; the reason we are here
8.  Emby          | Alternative to PLEX and less restrictive
9.  PlexyPy       | Provides detailed analytics about the PLEX Users
10. NetData       | Statistical tool
11. Muximux       | Self-managed site interface to control your programs   
12. Wordpress     | Create a website for users to interact with
13. RuTorrent     | Torrent Downloading Program (No-Guide)
14. NZBGET        | USENET Downloading Program (No-Guide) 
15. Exit
EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 15 ] " choice
	case $choice in
  1)
    echo ymlprogram sonarr > /opt/plexguide/tmp.txt
    echo ymldisplay Sonarr >> /opt/plexguide/tmp.txt
    echo ymlport 8989 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  2)
    echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
    echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
    echo ymlport 8090 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  3)
    echo ymlprogram radarr > /opt/plexguide/tmp.txt
    echo ymldisplay Radarr >> /opt/plexguide/tmp.txt
    echo ymlport 7878 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh  
    ;;
  4)
    echo ymlprogram couchpotato > /opt/plexguide/tmp.txt
    echo ymldisplay CouchPotato >> /opt/plexguide/tmp.txt
    echo ymlport 5050 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh 
    ;;
  5)
    echo ymlprogram organizr > /opt/plexguide/tmp.txt
    echo ymldisplay Organizr >> /opt/plexguide/tmp.txt
    echo ymlport 8020 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh 
    ;;
  6)
    echo ymlprogram ombi > /opt/plexguide/tmp.txt
    echo ymldisplay Ombi >> /opt/plexguide/tmp.txt
    echo ymlport 3579 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  7)
    echo ymlprogram plex > /opt/plexguide/tmp.txt
    echo ymldisplay Plex >> /opt/plexguide/tmp.txt
    echo ymlport 32400 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  8)
    echo ymlprogram emby > /opt/plexguide/tmp.txt
    echo ymldisplay Emby >> /opt/plexguide/tmp.txt
    echo ymlport 8096 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  9)
    echo ymlprogram plexpy > /opt/plexguide/tmp.txt
    echo ymldisplay PlexPY >> /opt/plexguide/tmp.txt
    echo ymlport 8181 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
	10)
    echo ymlprogram netdata > /opt/plexguide/tmp.txt
    echo ymldisplay NetData >> /opt/plexguide/tmp.txt
    echo ymlport 19999 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  11)
    echo ymlprogram muximux > /opt/plexguide/tmp.txt
    echo ymldisplay Muximux >> /opt/plexguide/tmp.txt
    echo ymlport 8015 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  12)
    echo ymlprogram wordpress > /opt/plexguide/tmp.txt
    echo ymldisplay WordPress >> /opt/plexguide/tmp.txt
    echo ymlport 80 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  13)
    echo ymlprogram rutorrent > /opt/plexguide/tmp.txt
    echo ymldisplay RuTorrent >> /opt/plexguide/tmp.txt
    echo ymlport 8085 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  14)
    echo ymlprogram nzbget > /opt/plexguide/tmp.txt
    echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
    echo ymlport 6789 >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
  15) 
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
