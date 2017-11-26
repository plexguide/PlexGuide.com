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
Only Install one version of RClone; encrypted or unencrypted. If you
switch; you can and I mitgated everything but reboot if making a switch.

For Test/Troubleshooting, use this to see if rclone and unionfs work.
Have at least one item in your google drive.  If you see it, it works!

~~~~~~~~~~~~~~~~
RClone Installer
~~~~~~~~~~~~~~~~
1. Unencrypted Install  :  Utilize the unencrypted version of RClone
2. Encrypted Install    :  Utilize the encrypted version of RClone
                           *****************************************
3. Unencrypt Mount Check:  Select Only if you ran the Unencrypt Install
4. Encrypted Mount Check:  Select Only if you ran the Encrypted Install
5. UnionFS Mount Test   :  Verify UnionFS is operational

EOF
}

read_options(){
	local choice
	read -p "Enter Choice [ 1 - 6 ];  Type [6] to Exit! " choice
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
    touch /mnt/gdrive/gdrivetest-encrypted.txt
    clear
    ls /mnt/gdrive
    echo
    echo "*** RClone Encrypted Your Google Drive - If empty, that's not good ***"
    echo "Note 1: You should at least see gdrivetest-encrypted.txt"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    clear
  	;;
	5)
		touch /mnt/move/uniontest.txt
		clear
		ls /mnt/unionfs
		echo
    echo "*** UnionFS: Your Google Drive - If empty, that's not good ***"
    echo "Note 1: You should at least see uniontest.txt"
    echo "Note 2: Once you finish the PLEXDRIVE4 setup, you should see the rest"
    read -n 1 -s -r -p "Press any key to continue "
    clear
		;;
	6)
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
