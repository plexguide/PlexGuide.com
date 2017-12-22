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
Plexpy SELECT
~~~~~~~~~~~~~~~~~~

Note, tautilli is Plexpy v2.0, but is still in beta status, so don't expect everyting to work. 

1. Install Latest Plexpy
2. Install Latest tautulli

EOF
}

read_options(){
        local choice
        read -p "Enter choice [ 1 - 3 ];  Type [3] to Exit!  " choice
        case $choice in
                1)       
        echo ymlprogram plexpy > /opt/plexguide/tmp.txt
        echo ymldisplay PlexPY >> /opt/plexguide/tmp.txt
        echo ymlport 8181 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        clear
      ;;
                2)
       echo ymlprogram tautulli > /opt/plexguide/tmp.txt
        echo ymldisplay tautulli >> /opt/plexguide/tmp.txt
        echo ymlport 8181 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        clear
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
