 #!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Service Status Menu" --menu "Make your choice" 17 34 10 \
    "1)" "Unencrypted: PlexDrive"   \
    "2)" "Encrypted: PlexDrive"  \
    "3)" "Unencrypted: RClone"  \
    "4)" "Encrypted: RClone"  \
    "5)" "Unencrypted: UnionFS"  \
    "6)" "Encrypted: UnionFS"  \
    "7)" "Unencrypted: Move"  \
    "8)" "Encrypted: Move"  \
    "9)" "Restart Menu"   \
    "10)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/plexdrive.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/plexdrive.log
      fi

      ## obtains plexdrive.service info and puts into a log to be displayed to the user
      clear
      systemctl status plexdrive > /opt/plexguide/plexdrive.log
      cat /opt/plexguide/plexdrive.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "2)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/rclone-en.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/rclone.log
      fi

      ## obtains rclone-en.service info and puts into a log to be displayed to the user
      clear
      systemctl status rclone-en > /opt/plexguide/rclone-en.log
      cat /opt/plexguide/rclone-en.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "3)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/rclone.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/rclone.log
      fi

      ## obtains rclone.service info and puts into a log to be displayed to the user
      clear
      systemctl status rclone > /opt/plexguide/rclone.log
      cat /opt/plexguide/rclone.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "4)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/rclone-encrypt.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/rclone-encrypt.log
      fi

      ## obtains rclone-encrypt.service info and puts into a log to be displayed to the user
      clear
      systemctl status rclone-encrypt > /opt/plexguide/rclone-encrypt.log
      cat /opt/plexguide/rclone-encrypt.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;

    "5)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/unionfs.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/unionfs.log
      fi

      ## obtains unionfs.service info and puts into a log to be displayed to the user
      clear
      systemctl status unionfs > /opt/plexguide/unionfs.log
      cat /opt/plexguide/unionfs.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "6)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/unionfs-encrypt.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/unionfs-encrypt.log
      fi

      ## obtains unionfs-encrypt.service info and puts into a log to be displayed to the user
      clear
      systemctl status unionfs-encrypt > /opt/plexguide/unionfs-encrypt.log
      cat /opt/plexguide/unionfs-encrypt.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "7)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/move.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/move.log
      fi

      ## obtains move.service info and puts into a log to be displayed to the user
      clear
      systemctl status move > /opt/plexguide/move.log
      cat /opt/plexguide/move.log
      echo
      echo "*** View the Log ***"
      echo "Remember, there is a sleep function of 30 minutes after done"
      echo "If you have tons of stuff downloaded, you should see some activity"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "8)")
      ## create log file if does not exist
      if [ -e "/opt/plexguide/move-en.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/move-en.log
      fi

      ## obtains move-en.service info and puts into a log to be displayed to the user
      clear
      systemctl status move-en > /opt/plexguide/move-en.log
      cat /opt/plexguide/move-en.log
      echo
      echo "*** View the Log ***"
      echo "Remember, there is a sleep function of 30 minutes after done"
      echo "If you have tons of stuff downloaded, you should see some activity"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "9)")
        clear
        bash /opt/plexguide/scripts/menus/restart-menu.sh
        clear
        ;;


     "10)")
      clear
      exit 0
      ;;
esac
done
exit
