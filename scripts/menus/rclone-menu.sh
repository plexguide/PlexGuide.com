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
Note: Ensure that you run the Pre-Install [1] prior to anything else.

Only Install one version of RClone; encrypted or unencrypted

~~~~~~~~~~~~~~~~~~~~
  RClone Installer
~~~~~~~~~~~~~~~~~~~~
1. RClone Preinstall  :  Enables Services & UnionFS
2. Unencrypted Install:  Utilize the unencrypted version of RClone
3. Encrypted Install  :  Utilize the encrypted version of RClone
4. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
	1)
		bash /opt/plexguide/scripts/docker-no/rclone-basic.sh
        clear
        echo "*** RClone Pre-Install Complete ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
		;;
	2)
		bash /opt/plexguide/scripts/docker-no/rclone-un.sh
        ;;
	3)
		bash /opt/plexguide/scripts/docker-no/rclone-en.sh
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


            
