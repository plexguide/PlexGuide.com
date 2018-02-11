
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "RClone Menu" --menu "Make your choice" 10 36 3 \
    "1)" "Unencrypted RClone Install"   \
    "2)" "Encrypted RClone Install"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
        bash /opt/plexguide/scripts/docker-no/rclone-un.sh
        ;;

    "2)")
        bash /opt/plexguide/scripts/docker-no/rclone-en.sh
        ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
