 #!/bin/bash
 #
 # [PlexGuide Menu]
 #
 # GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
 # Author:   Admin9705 - Deiteq
 # URL:      https://plexguide.com
 #
 # PlexGuide Copyright (C) 2018 PlexGuide.com
 # Licensed under GNU General Public License v3.0 GPL-3 (in short)
 #
 #   You may copy, distribute and modify the software as long as you track
 #   changes/dates in source files. Any modifications to our software
 #   including (via compiler) GPL-licensed code must also be made available
 #   under the GPL along with build & install instructions.
 #
 #################################################################################

 export NCURSES_NO_UTF8_ACS=1
 HEIGHT=12
 WIDTH=36
 CHOICE_HEIGHT=6
 BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
 TITLE="PG Services Status Menu"
 MENU="Make a Selection Choice:"

 OPTIONS=(A "Unencrypted: Cache"
          B "Encrypted: Cache"
          C "UnionFS"
          D "Move"
          E "Restart Menu"
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
      if [ -e "/opt/plexguide/cache.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/cache.log
      fi

      ## obtains cache.service info and puts into a log to be displayed to the user
      clear
      systemctl status cache > /opt/plexguide/cache.log
      cat /opt/plexguide/cache.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    B)
      ## create log file if does not exist
      if [ -e "/opt/plexguide/encache.log" ]
      then
        echo "Log exists"
      else
        touch /opt/plexguide/encache.log
      fi

      ## obtains encache.service info and puts into a log to be displayed to the user
      clear
      systemctl status encache > /opt/plexguide/encache.log
      cat /opt/plexguide/encache.log
      echo
      echo "*** View the Log ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    C)
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

    D)
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
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
  		;;

    E)
        clear
        bash /opt/plexguide/menus/info-tshoot/info2/restart-menu.sh
        clear
      ;;

     Z)
      clear
      exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info-tshoot/info2/status-menu.sh
