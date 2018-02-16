 #!/bin/bash
##clear screen
clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "PlexDrive Menu" --menu "Make your choice" 10 40 3 \
    "1)" "PlexDrive Install"   \
    "2)" "Remove PlexDrive Tokens"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
        bash /opt/plexguide/scripts/docker-no/plexdrive.sh
#        bash /opt/plexguide/scripts/docker-no/plexdrive.sh
        ;;

    "2)")
        rm -r /root/.plexdrive 1>/dev/null 2>&1
        rm -r ~/.plexdrive 1>/dev/null 2>&1
        echo
        echo "Tokens Removed - Try PlexDrive Install Again"
        echo
        read -n 1 -s -r -p "Press any key to continue"
        clear
        ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
