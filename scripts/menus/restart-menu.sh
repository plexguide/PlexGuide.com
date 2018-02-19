 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Service Restart Menu" --menu "Make your choice" 16 34 9 \
    "1)" "Unencrypted: PlexDrive"   \
    "2)" "Encrypted: PlexDrive"  \
    "3)" "Unencrypted: RClone"  \
    "4)" "Encrypted: RClone"  \
    "5)" "Unencrypted: UnionFS"  \
    "6)" "Encrypted: UnionFS"  \
    "7)" "Unencrypted: Move"  \
    "8)" "Encrypted: Move"  \
    "9)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      clear
      systemctl restart plexdrive
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "2)")
        clear
        systemctl restart rclone-en
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        ;;

    "3)")
      clear
      systemctl restart rclone
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "4)")
      clear
      systemctl restart rclone-encrypt
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "5)")
      clear
      systemctl restart unionfs
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      clear
        ;;

    "6)")
        clear
        systemctl restart unionfs-encrypt
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

    "7)")
        clear
        systemctl restart move
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

    "8)")
        clear
        systemctl restart move-en
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;


     "9)")
      clear
      exit 0
      ;;
esac
done
exit
