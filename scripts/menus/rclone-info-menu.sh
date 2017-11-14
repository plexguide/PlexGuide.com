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
~~~~~~~~~~~~~~~~~~~~~~~~
    RCLONE TUTORIAL
~~~~~~~~~~~~~~~~~~~~~~~~

Please visit http://wiki.plexguide.com for any tutorial information.  It is
recommended to view the following guides:

*** Unencrypt RClone - http://unrclone.plexguide.com
*** Encrypted  RClone - http://enrclone.plexguide.com

Note, ensure that you conducted install [1] RClone Pre-Install.  Forgetting to
do so will cause some grief.

1. View Unencrypted Guide
2. View Encrypted Guide
3. Proceed onward to the RClone Install
4. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
		1)
    clear
    cat << EOF
Directory 1 (For Google Drive)
WARNING: Write this down and follow the order

N < For New remote
gdrive < for the name
9 < For Google Drive (double check the number select incase)
Enter Your Google ID
Enter Your Google Secret

Y < for GUI Interface (much easier if using a Graphical Interface)
N < for headless machine (if using only Terminal)

Enter Your Verification Code

Windows Users: Use CTRL+Insert (for copy) and Shift+Insert (for Paste)
Do anything else, you will mess it up

N < Configure this as a team drive?
Y < If asking all is ok?

EOF
    bash /opt/plexguide/scripts/docker-no/continue.sh

    cat << EOF
Directory 2 (Local Drive)
WARNING: Write this down and follow the order

N < For New remote
local < for the name
11 < For a Local Drive

Ignore this part about ... long file names, UNC, and selecting [1])
>>> Just type this exactly: /mnt/rclone-move and then press [ENTER]

Y < Is asking all is ok?
Q < to quit

EOF
    bash /opt/plexguide/scripts/docker-no/continue.sh

    ##### Final Note for Encrypted
        cat << EOF
PlexGuide.com
http://unrclone.plexguide.com

You can visit this area again.  Visiting the website is highly encouraged!
EOF
    bash /opt/plexguide/scripts/docker-no/continue.sh
      ;;
		2)
####### For Encryption Part 1
    clear
    cat << EOF
Maintained By - Deiteq
Part I of IV (For Google Drive)
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
gdrive < for the name
9 < For Google Drive (double check the number select incase)
Enter Your Google ID
Enter Your Google Secret

Y < for GUI Interface (much easier if using a Graphical Interface)
N < for headless machine (if using only Terminal)

Enter Your Verification Code

Windows Users: Use CTRL+Insert (for copy) and Shift+Insert (for Paste)
Do anything else, you will mess it up

N < Configure this as a team drive?
Y < If asking all is ok?

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh

####### For Encryption Part II
cat << EOF
Maintained By - Deiteq
Part II of IV
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
gcrypt < for the name
6 < For Encrypt/Decrypt (double check the number select incase)
gdrive:/encrypt (encrypt being the rclone encrypted folder within your gdrive)
2 < Encrypt standard
Y < type your own password (write it, secure it and do not lose it)
Y < type your own salt password (write it, secure it, make different from before)
Should see something like this:

[gcrypt]
remote = gdrive:/encrypt
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***

Y < Is asking all is ok?
EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

####### For Encryption Part III

cat << EOF
Maintained By - Deiteq
Part III of IV
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
crypt < for the name
6 < For Encrypt/Decrypt (double check the number select incase)
/mnt/plexdrive4/encrypt
2 < Encrypt standard
Y < type your own password (use same as before for gcrypt)
Y < type your own salt password (use same as before for gcrypt salt)
Should see something like this:

[crypt]
remote = /mnt/plexdrive4/encrypt
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***

Y < Is asking all is ok?

EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

##### For Encryption Part IV
cat << EOF
Maintained By - Deiteq
Part IV of IV
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
local < for the name
11 < For a Local Drive

Ignore this part about ... long file names, UNC, and selecting [1])
>>> Just type this exactly: /mnt/rclone-move and then press [ENTER]

Y < Is asking all is ok?
Q < to quit
EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

##### Final Note for Encrypted
cat << EOF
Maintained By - Deiteq
http://enrclone.plexguide.com

You can visit this area again.  Visiting the website is highly encouraged!
EOF
bash /opt/plexguide/scripts/docker-no/continue.sh
      ;;
    3)
bash /opt/plexguide/scripts/menus/rclone-menu.sh
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
