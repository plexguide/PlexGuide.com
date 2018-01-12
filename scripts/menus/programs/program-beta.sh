 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Media Choice" --menu "Make your choice" 10 30 3 \
    "1)" "VPN Torrent"   \
    "2)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

    "1)")
    clear
    bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh
    ;;

     "2)")
      clear
      exit 0
      ;;
esac
done
exit
