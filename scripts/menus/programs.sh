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
PlexGuide.com Installer/Upgrader

===== Confirmed Working Programs ===================================
1.  Plex       | Sharing media Program - * The Reason We Are Here *
2.  Emby       | Sharing Media Program - Secondary Alternative
3.  NetData    | Statistical Tool for the Server
4.  Muximux    | ** Site Interface to control your programs
5.  Ombi v3    | ** Enables users to request media
6.  Organizr   | ** Site Interface to control your programs
7.  PlexPy     | Provides analytics about your PLEX Users
8.  Radarr     | Movie requesting program; newer less mature program
9.  SABNZBD    | USENET Downloading Program
10. Sonarr     | TV Show requesting program (Recommended)
11. Wordpress  | Create a website for users to interact

EOF
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 12 ];  Type [12] to Exit! " choice
	case $choice in
    1)
     echo ymlprogram emby > /opt/plexguide/tmp.txt
     echo ymldisplay Emby >> /opt/plexguide/tmp.txt
     echo ymlport 8096 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
    1)
     clear
     bash /opt/plexguide/scripts/menus/plexsub-menu.sh
     ;;
    2)
     echo ymlprogram netdata > /opt/plexguide/tmp.txt
     echo ymldisplay NetData >> /opt/plexguide/tmp.txt
     echo ymlport 19999 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
    3)
     echo ymlprogram muximux > /opt/plexguide/tmp.txt
     echo ymldisplay Muximux >> /opt/plexguide/tmp.txt
     echo ymlport 8015 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
    4)
     echo ymlprogram ombi > /opt/plexguide/tmp.txt
     echo ymldisplay Ombi >> /opt/plexguide/tmp.txt
     echo ymlport 3579 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
    5)
     echo ymlprogram organizr > /opt/plexguide/tmp.txt
     echo ymldisplay Organizr >> /opt/plexguide/tmp.txt
     echo ymlport 8020 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
    6)
     echo ymlprogram plexpy > /opt/plexguide/tmp.txt
     echo ymldisplay PlexPY >> /opt/plexguide/tmp.txt
     echo ymlport 8181 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
     7)
      echo ymlprogram radarr > /opt/plexguide/tmp.txt
      echo ymldisplay Radarr >> /opt/plexguide/tmp.txt
      echo ymlport 7878 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;
      8)
      echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
      echo ymlport 8090 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;
      9)
        echo ymlprogram sonarr > /opt/plexguide/tmp.txt
        echo ymldisplay Sonarr >> /opt/plexguide/tmp.txt
        echo ymlport 8989 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        ;;
      10)
        echo ymlprogram wordpress > /opt/plexguide/tmp.txt
        echo ymldisplay WordPress >> /opt/plexguide/tmp.txt
        echo ymlport 80 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        ;;
      11)
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
