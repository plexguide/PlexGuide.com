 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Make A Selection" --menu "Make your choice" 12 34 5 \
    "1)" "Information"   \
    "2)" "Troubleshooting"  \
    "3)" "View Service Status"  \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
     clear
     bash /opt/plexguide/scripts/menus/info-menu.sh
     ;;

    "2)")
    clear
    bash /opt/plexguide/scripts/menus/trouble-menu.sh
    ;;

    "3)")
      clear
      bash /opt/plexguide/scripts/menus/status-menu.sh
      ;;

    "4)")
        clear
        exit 0
        ;;
esac
done
exit
