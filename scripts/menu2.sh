#!/bin/bash

apt-get install dialog

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 8 \
    "1" "Display System Information" \
    "2" "Display Disk Space" \
    "3" "Display Home Space Utilization" \
    "4" "Display System Information" \
    "5" "Display Disk Space" \
    "6" "Display Home Space Utilization" \
    "7" "Display Disk Space" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    1)
        bash /opt/plexguide/scripts/plexmenu.sh
        ;;
    2)
        clear
        echo "*** This Area is Not Ready - Use @ Your Own Risk ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        cd /opt/plexguide/scripts/
        bash rclone-menu.sh
        ;;
    3)
        cd /opt/plexguide/scripts/
        bash dep2.sh
        bash individual-menu.sh
        ;;
    4)
        clear
        echo "*** This Area is Not Ready ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
        5)
        cd /opt/plexguide/scripts/
        bash upgrade.sh
        clear
        echo You are required to restart the program.
        echo Restart the program afterwards by typing:  plexguide
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        echo Remember, restart by typing:  plexguide
        exit 0;;
    6)
        cd /opt/plexguide/scripts/
        bash mass.sh
            ;;
    7)
        clear
        echo "*** This Area is Not Ready ***"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;
    esac
done