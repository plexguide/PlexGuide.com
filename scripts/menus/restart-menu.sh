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
Restart Services

Plexdrive - Can use both for Encrypted *******************************

1. Plexdrive4           :  Restart of the Plexdrive4 service
2. Plexdrive4-Encrypt   :  Restart of the Plexdrive4 Encrypted service

RClone - Can use both for Encrypted *********************************

3. RClone               :  Restart of the RClone Unencrypted service
4. RClone-Encrypt       :  Restart of the RClone Encrypted service

UnionFS - Only use 1 ************************************************

5. UnionFS              :  Restart of the Unencrypted service
6. UnionFS-Encrypt      :  Restart of the Encrypted service

Move - Only use 1 ***************************************************

7. Move                 :  Restart of the Unencrypted SYNC service
8. Move-Encrypt         :  Restart of the Encrypted SYNC service

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 ];  Type [9] to Exit! " choice
	case $choice in
    1)
      ## restart plexdrive4.service
      clear
      systemctl restart plexdrive4
      read -n 1 -s -r -p "Press any key to continue "
      ;;
      2)
        ## restart rclone-en.service
        clear
        systemctl restart rclone-en
        read -n 1 -s -r -p "Press any key to continue "
        ;;
  	3)
      ## restart rclone.service
      clear
      systemctl restart rclone
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
  	4)
      ## restart rclone-encrypt.service
      clear
      systemctl restart rclone-encrypt
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;
      5)
      ## restart unionfs.service
      clear
      systemctl restart unionfs
        read -n 1 -s -r -p "Press any key to continue "
        clear
    		;;

    6)
    ## restart unionfs-encrypt.service
    clear
    systemctl restart unionfs-encrypt
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;
        7)
        ## restart move.service
        clear
        systemctl restart move
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
        8)
        ## restart move-en.service
        clear
        systemctl restart move-en
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
