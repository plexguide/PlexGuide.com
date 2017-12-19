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
Service Status Checks

Plexdrive Test *********************************************************

1. Plexdrive4      :  View status of the Plexdrive4 service

RClone Tests - Can use all 3 for Encrypted *****************************

2. RClone          :  View status of the RClone Unencrypted service
3. RClone-En       :  View status of the Plexdrive4 Encrypted service
4. RClone-Encrypt  :  View status of the RClone Encrypted service

UnionFS Tests - Only use 1 *********************************************

5. UnionFS         :  View status of the Unencrypted service
6. UnionFS-Encrypt :  View status of the Encrypted service

Move Tests - Only use 1 ************************************************

7. Move            :  View status of the Unencrypted SYNC service
8. Move-Encrypt    :  View status of the Encrypted SYNC service

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 ];  Type [9] to Exit! " choice
	case $choice in
    1)
      ## create log file if does not exist
      if [ -e "/opt/plexguide/plexdrive4.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/plexdrive4.log
      fi

      ## obtains move.service info and puts into a log to displayed to the user
      clear
      systemctl status plexdrive4 > /opt/plexguide/plexdrive4.log
      cat /opt/plexguide/plexdrive4.log
      echo
      echo "*** View the Log ***"
      echo "Remember, there is a sleep function of 30 minutes after done"
      echo "If you have tons of stuff downloaded, you should see some activity"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;
      2)
        ## create log file if does not exist
        if [ -e "/opt/plexguide/rclone.log" ]
        then
          echo "Log exists"
        else
          touch /opt/plexguide/rclone.log
        fi

        ## obtains move.service info and puts into a log to displayed to the user
        clear
        systemctl status rclone > /opt/plexguide/rclone.log
        cat /opt/plexguide/rclone.log
        echo
        echo "*** View the Log ***"
        echo "Remember, there is a sleep function of 30 minutes after done"
        echo "If you have tons of stuff downloaded, you should see some activity"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        ;;
  	3)
      ## create log file if does not exist
      if [ -e "/opt/plexguide/rclone-en.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/rclone-en.log
      fi

      ## obtains move.service info and puts into a log to displayed to the user
      clear
      systemctl status rclone-en > /opt/plexguide/rclone-en.log
      cat /opt/plexguide/rclone-en.log
      echo
      echo "*** View the Log ***"
      echo "Remember, there is a sleep function of 30 minutes after done"
      echo "If you have tons of stuff downloaded, you should see some activity"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
  	4)
      ## create log file if does not exist
      if [ -e "/opt/plexguide/rclone-encrypt.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/rclone-encrypt.log
      fi

      ## obtains move.service info and puts into a log to displayed to the user
      clear
      systemctl status rclone-encrypt > /opt/plexguide/rclone-encrypt.log
      cat /opt/plexguide/rclone-encrypt.log
      echo
      echo "*** View the Log ***"
      echo "Remember, there is a sleep function of 30 minutes after done"
      echo "If you have tons of stuff downloaded, you should see some activity"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;
      5)
        ## create log file if does not exist
        if [ -e "/opt/plexguide/unionfs.log" ]
        then
          echo "Log exists"
        else
          touch /opt/plexguide/unionfs.log
        fi

        ## obtains move.service info and puts into a log to displayed to the user
        clear
        systemctl status unionfs > /opt/plexguide/unionfs.log
        cat /opt/plexguide/unionfs.log
        echo
        echo "*** View the Log ***"
        echo "Remember, there is a sleep function of 30 minutes after done"
        echo "If you have tons of stuff downloaded, you should see some activity"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
    		;;

    6)
      ## create log file if does not exist
      if [ -e "/opt/plexguide/unionfs-encrypt.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/unionfs-encrypt.log
      fi

      ## obtains move.service info and puts into a log to displayed to the user
      clear
      systemctl status unionfs-encrypt > /opt/plexguide/unionfs-encrypt.log
      cat /opt/plexguide/unionfs-encrypt.log
      echo
      echo "*** View the Log ***"
      echo "Remember, there is a sleep function of 30 minutes after done"
      echo "If you have tons of stuff downloaded, you should see some activity"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
        7)
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
