 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Information Menu" --menu "Make your choice" 15 54 8 \
    "1)" "View HardDrive Space"   \
    "2)" "Check storage space with NCDU"  \
    "3)" "View Container Info"  \
    "4)" "Verify PlexDrive"  \
    "5)" "Verify UnionFS"  \
    "6)" "Verify UN-RClone"  \
    "7)" "Verify EN-RClone"  \
    "8)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      clear
      df -h --total
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "2)")
      clear
      bash /opt/plexguide/scripts/menus/ncdu
      ;;

    "3)")
        clear
        ctop
        ;;

    "4)")
      clear
      ls /mnt/plexdrive
      echo
      echo "*** PlexDrive: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: Must have at least 1 item in your Google Drive for the test"
      echo "Note 2: Once you finish the PLEXDRIVE setup, you'll see everything!"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "5)")
      touch /mnt/move/uniontest.txt
      clear
      ls /mnt/unionfs
      echo
      echo "*** UnionFS: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see uniontest.txt"
      echo "Note 2: Once PLEXDRIVE is setup, you should see the rest"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "6)")
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

    "7)")
        touch /mnt/.gcrypt/gdrivetest.txt
        clear
        ls /mnt/.gcrypt
        echo
        echo "*** RClone: Your Google Drive - If empty, that's not good ***"
        echo "Note 1: You should at least see gdrivetest.txt"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

      "8)")
      clear
      exit 0
      ;;
esac
done
exit
