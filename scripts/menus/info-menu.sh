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
Tools & Troubleshooting 101 Menu

Basic Checks ***********************************************
1. HD Space      :  View HD Stats
2. Containers    :  View Space Containers Are Using
3. PlexDrive     :  Veryify that PlexDrive is Working

Uncrypted Tests ********************************************
4. RClone Test   :  Verify Google Drive is Mounted
5. UN-SYNC (Move):  View status of the Unencrypted SYNC

UnionFS Test ***********************************************
6. UnionFS    :  Verify UnionFS is Operational

Encrypted Tests ********************************************
7. EN-RClone     :  Verify Encrypted Google Drive is Mounted
8. EN-SYNC (Move):  View status of the Encrypted SYNC

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 ];  Type [9] to Exit! " choice
	case $choice in
    1)
      clear
      df -h --total
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;
      2)
        clear
        docker ps -s
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        ;;
  	3)
      clear
      ls /mnt/plexdrive4
      echo
      echo "*** PlexDrive4: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: Must have at least 1 item in your Google Drive for the test"
      echo "Note 2: Once you finish the PLEXDRIVE4 setup, you'll see everything!"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
  	4)
      touch /mnnt/gdrive/gdrivetest.txt
      clear
      ls /mnt/gdrive
  		echo
      echo "*** RClone: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see gdrivetest.txt"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;
      5)
        ## create log file if does not exist
        if [ -e "/opt/plexguide/move.log" ]
        then
          echo "Log exists"
        else
          touch /opt/plexguide/move.log
        fi
        ## obtains move.service info and puts into a log to displayed to the user
    		clear
    		systemctl status move > /opt/plexguide/move.log
        cat /opt/plexguide/move.log
    		echo
        echo "*** View the Log ***"
        echo "Remember, there is a sleep function of 30 minutes after done"
        echo "If you have tons of stuff downloaded, you should see some activity"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
    		;;

    6)
      touch /mnt/move/uniontest.txt
      clear
      ls /mnt/unionfs
      echo
      echo "*** UnionFS: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see uniontest.txt"
      echo "Note 2: Once PLEXDRIVE4 is setup, you should see the rest"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
        7)
        touch /mnt/.gcrypt/gdrivetest.txt
        clear
        ls /mnt/.gcrypt
        echo
        echo "*** RClone: Your Google Drive - If empty, that's not good ***"
        echo "Note 1: You should at least see gdrivetest.txt"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
        8)
          ## create log file if does not exist
          if [ -e "/opt/plexguide/move-en.log" ]
          then
            echo "Log exists"
          else
            touch /opt/plexguide/move-en.log
          fi

          ## obtains move.service info and puts into a log to displayed to the user
          clear
          systemctl status move-en > /opt/plexguide/move-en.log
          cat /opt/plexguide/move-en.log
          echo
          echo "*** View the Log ***"
          echo "Remember, there is a sleep function of 30 minutes after done"
          echo "If you have tons of stuff downloaded, you should see some activity"
          echo
          read -n 1 -s -r -p "Press any key to continue "
          clear
          ;;
        9)
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
