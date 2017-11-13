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

Only Install one version of RClone; encrypted or unencrypted. If you
switch; you can and I mitgated everything but reboot if making a switch.

For Test/Troubleshooting, use this to see if rclone and unionfs work.
Have at least one item in your google drive.  If you see it, it works!

~~~~~~~~~~~~~~~~
RClone Installer
~~~~~~~~~~~~~~~~
1. RClone Preinstal    :  Enables Services & UnionFS
                          *****************************************
2. Unencrypted Install :  Utilize the unencrypted version of RClone
3. Encrypted Install   :  Utilize the encrypted version of RClone
                          *****************************************
4. RClone Mount Test UN:  [Unencrypt] Check Unenrcypt RClone Mount
5. RClone Mount Test EN:  [Encrypted] Check Encrypted RClone Mount
6. UnionFS Mount Test  :  Check if the UnionFS mount works
7. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 ] " choice
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
		clear
		ls /mnt/rclone
		echo
        echo "*** Unencrypted RClone: Your Google Drive - If empty, that's not good ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
		;;
    5)
  		clear
  		ls /mnt/rclone
  		echo
          echo "*** This checker does not work yet for encrypted ***"
          echo
          read -n 1 -s -r -p "Press any key to continue "
          clear
  		;;
	6)
		touch /mnt/rclone-move/uniontest.txt
		clear
		ls /mnt/rclone-union
		echo
        echo "*** UnionFS: Your Google Drive - If empty, that's not good ***"
        echo "Note 1: You should at least see uniontest.txt"
        echo "Note 2: Once you finish the PLEXDRIVE4 setup, you should see the rest"
        read -n 1 -s -r -p "Press any key to continue "
        clear
		;;
	7)
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
