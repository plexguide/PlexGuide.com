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
~~~~~~~~~~~~~~~~~~~~~~~
    RCLONE WARNING
~~~~~~~~~~~~~~~~~~~~~~~

Please visit http://wiki.plexguide.com for any tutorial information.  It is
recommended to view the following guides:

*** GoogleAPI        - http://googleapi.plexguide.com
*** Unencrypt RClone - http://unrclone.plexguide.com
*** Encrypted RClone - http://enrclone.plexguide.com

Not reading or following the guides will cause you some grief!


EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

clear
cat << EOF
Note: Only Install one version of RClone; encrypted or unencrypted. If you
switch; you can. I mitgated everything but reboot if making a switch.

~~~~~~~~~~~~~~~~
RClone Installer
~~~~~~~~~~~~~~~~
1. Unencrypted Install  :  Utilize the unencrypted version of RClone
2. Encrypted Install    :  Utilize the encrypted version of RClone
                           *****************************************
3. Unencrypt Mount Check:  Select Only if you ran the Unencrypt Install
4. Encrypted Mount Check:  Select Only if you ran the Encrypted Install
EOF
}

read_options(){
	local choice
	read -p "Enter Choice [ 1 - 5 ];  Type [5] to Exit! " choice
	case $choice in
	1)
		bash /opt/plexguide/scripts/docker-no/rclone-un.sh
		;;
	2)
		bash /opt/plexguide/scripts/docker-no/rclone-en.sh
    ;;
	3)
    touch /mnt/gdrive/gdrivetest-unencrypted.txt
    clear
    ls /mnt/gdrive
    echo
    echo "*** RClone Unencrypt: Your Google Drive - If empty, that's not good ***"
    echo "Note 1: You should at least see gdrivetest-unecrypted.txt"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    clear
	  ;;
    4)
    touch /mnt/.gcrypt/gdrivetest-encrypted.txt
    clear
    ls /mnt/encrypt
    echo
    echo "*** RClone Encrypted Your Google Drive - If empty, that's not good ***"
    echo "Note 1: You should at least see gdrivetest-encrypted.txt"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    clear
  	;;
	5)
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
