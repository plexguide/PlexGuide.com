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

1. PlexDrive Test  :  Veryify that PlexDrive is Working
2. RClone Test     :  Verify Google Drive is Mounted
3. UnionFS Test    :  Verify UnionFS is Operational
4. Uncrypted Move  :  View status of the Unencrypted SYNC
5. Encrypted Move  :  View status of the Encrypted SYNC
                      **************************************
6. Start Re-Install:  Forces Startup Reinstall (Last Resort)
                      **************************************
7. Docker          :  Force Reinstall Docker
8. Portainer       :  Force Reinstall Portainer
9. NGINX-Proxy     :  Force Reinstall NGINX-Proxy

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 10 ];  Type [10] to Exit! " choice
	case $choice in
  	1)
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
  	2)
      touch /mnt/gdrive/gdrivetest.txt
      clear
      ls /mnt/gdrive
  		echo
      echo "*** RClone: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see gdrivetest.txt"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;
  	3)
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
      4)
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
        5)
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
    6)
      clear
      rm -r /var/plexguide/dep*
       bash /opt/plexguide/scripts/test/reinstall-rclone.sh
      # bash /opt/plexguide/scripts/test/reinstall-plexdrive.sh
      echo
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
        ;;
    7)
      # Install Docker and Docker Composer / Checks to see if is installed also
      clear
      echo "Note, if you get a message about docker is install and the 20 sec sleep"
      echo "warning, just ignore it and let the 20 seconds go by."
      echo
      curl -sSL https://get.docker.com | sh
      curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d
      ############################################# Install a Post-Docker Fix ###################### START
    ;;
    8)
     echo ymlprogram portainer > /opt/plexguide/tmp.txt
     echo ymldisplay Portainer >> /opt/plexguide/tmp.txt
     echo ymlport 9000 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;
    9)
    echo ymlprogram nginx-proxy> /opt/plexguide/tmp.txt
    echo ymldisplay nginx-proxy >> /opt/plexguide/tmp.txt
    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    ;;
    10)
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
