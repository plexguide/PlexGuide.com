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
PLEX SERVER SELECT
~~~~~~~~~~~~~~~~~~

Note, if you install the PlexPass version and do not have PlexPass, it will
just revert to the normal version. If your installing this on a REMOTE
computer, please visit http://wiki.plexguide.com so you access the server!

1. Run environment install
2. Install Latest Plex Server
3. exit
4. PlexToken

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3 ];  Type [3] to Exit!  " choice
	case $choice in
		1)
    clear
    rm /opt/appdata/.plex-env
    clear
    bash /opt/plexguide/roles/z_old2/plex.sh
    ;;
		2)

        echo ymlprogram nginx-plexpass > /opt/plexguide/tmp.txt
        echo ymldisplay NGINX-PlexPass >> /opt/plexguide/tmp.txt
        echo ymlport 32400 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/roles/z_old/program-installer.sh
        clear
        ##else
        #echo
        #echo "Are you Special? You need to setup your PLEXTOKEN FIRST!!!"
        #echo
        #read -n 1 -s -r -p "Press any key to continue "
        ##fi
      ;;
      3)
      exit 0;;
      4)
      clear
      echo "Visit http://plex.tv/claim"
      echo
      read -p "What is your Plex Claim Token? " pms_token
      echo "PMS_TOKEN=$pms_token" >> /opt/appdata/.plex-env
      clear
      touch /var/plexguide/plextoken.yes
      echo "Your PlexToken is Installed for the Easy Setup!"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;
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
