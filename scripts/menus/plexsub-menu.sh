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
~~~~~~~~~~~~~~~~~~~~~~~~
   PLEX SERVER SELECT
~~~~~~~~~~~~~~~~~~~~~~~~

Note, if you install the PlexPass version and do not have PlexPass, it will
just revert to the normal version. If your installing this on a REMOTE
computer, please visit http://wiki.plexguide.com so you access the server!

1. TESTING // CLAIM Plex Server
2. Install Latest Plex Server (Public - Stable)
3. Install Latest Plex Server (Pass - Unstable)
4. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3 ] " choice
	case $choice in
    1)
    read -p "What is your Plex Claim Token (http://plex.tv/claim)? " pmstoken
    echo "PMSTOKEN=$pmstoken" >> /opt/plexguide/scripts/docker/.env
    clear 
    echo "Your PlexToken is Installed for the Easy Setup!"
    echo
    touch /
    read -n 1 -s -r -p "Press any key to continue "
    ;;
		2)
if [ -e "opt/plexguide/scripts/docker-no/plex-token" ]
then
      docker rm plexpass
      docker rm plexpublic
      clear
      echo ymlprogram plexpublic > /opt/plexguide/tmp.txt
      echo ymldisplay Plex Public >> /opt/plexguide/tmp.txt
      echo ymlport 32400 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
          clear
else
    bash 
fi
      ;;
		3)
      docker rm plexpublic
      docker rm plexpass
      clear
      echo ymlprogram plexpass > /opt/plexguide/tmp.txt
      echo ymldisplay Plex Pass >> /opt/plexguide/tmp.txt
      echo ymlport 32400 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
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
