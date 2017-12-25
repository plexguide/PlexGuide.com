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
Troubleshooting 101 Menu - Be aware that if you select option 
[1], you will not lose your data.  It completely uninstalls 
Docker and removes all containers.  From there, it will execute
option [2] and reinstall everything.  All you have to do is 
recreate your containers.  Data is not lost.  It is preserved in
/opt/appdata!  Enjoy!

1. Remove Containers:  No Data Loss! Just Recreate Cotainers
                       *************************************
2. Force PreInstall :  Forces Startup PreInstall
                       *************************************
3. Docker           :  Force Reinstall Docker
4. Portainer        :  Force Reinstall Portainer
5. User: plexguide  :  Force recreation and password change

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 6 ];  Type [6] to Exit! " choice
	case $choice in
    1)
      echo "Uninstall Docker"
      echo 
      apt-get purge docker-ce
      rm -rf /var/lib/docker
      clear
      read -n 1 -s -r -p "Docker Uninstalled - All Containers Removed"
      rm -r /var/plexguide/dep*
      clear
      echo ""
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;
    2)
      clear
      rm -r /var/plexguide/dep*
      echo
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
        ;;
    3)
      clear
      echo "Note, if you get a message about docker is installed and the 20 sec sleep"
      echo "warning, just ignore it and let the 20 seconds go by."
      echo
      curl -sSL https://get.docker.com | sh
      curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d
      ;;
    4)
      docker stop portainer
      docker rm portainer
      rm -r /opt/appdata/portainer
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer
     ;;
    5)
      clear
      rm -r /var/plexguide/plexguide.user
      echo
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      exit
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
