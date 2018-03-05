 #!/bin/bash
 export NCURSES_NO_UTF8_ACS=1
 HEIGHT=18
 WIDTH=36
 CHOICE_HEIGHT=12
 BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
 TITLE="PG Services Status Menu"
 MENU="Make a Selection Choice:"

 OPTIONS=(A "Unencrypted: PlexDrive"
          B "Encrypted: PlexDrive"
          C "Unencrypted: RClone"
          D "Encrypted: RClone"
          E "Unencrypted: UnionFS"
          F "Encrypted: UnionFS"
          G "Unencrypted: Move"
          H "Encrypted: Move"
          I "Restart Menu"
          X "Back to Main Menu"
          Z "Exit")


 CHOICE=$(dialog --clear \
                 --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

 clear
case $CHOICE in
    A)
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

    B)
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

    C)
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

    D)
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

    E)
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

    F)
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

    G)
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

    H)
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

    I)
        clear
        bash /opt/plexguide/menus/info-tshoot/info/restart-menu.sh
        clear
        ;;

    X)
        clear
        bash /opt/plexguide/menus/main.sh
        clear
        ;;

     Z)
      clear
      exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info-tshoot/info/status-menu.sh
