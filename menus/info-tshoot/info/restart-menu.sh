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
 HEIGHT=16
 WIDTH=36
 CHOICE_HEIGHT=10
 BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
 TITLE="PG Services Restart Menu"
 MENU="Make a Selection Choice:"

 OPTIONS=(A "Unencrypted: PlexDrive"
          B "Encrypted: PlexDrive"
          C "Unencrypted: RClone"
          D "Encrypted: RClone"
          E "Unencrypted: UnionFS"
          F "Encrypted: UnionFS"
          G "Unencrypted: Move"
          H "Encrypted: Move"
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
        clear
        systemctl restart plexdrive
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
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo ""
        read -n 1 -s -r -p "PlexDrive service restarted!    -   Press any key to continue "
        ;;

    B)
        clear
        systemctl restart rclone-encrypt
        ## create log file if does not exist
        if [ -e "/opt/plexguide/rclone-encrypt.log" ]
        then
            echo "Log exists"
        else
            touch /opt/plexguide/rclone.log
        fi

        ## obtains rclone-encrypt.service info and puts into a log to be displayed to the user
        clear
        systemctl status rclone-encrypt > /opt/plexguide/rclone-encrypt.log
        cat /opt/plexguide/rclone-encrypt.log
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo ""
        read -n 1 -s -r -p "PlexDrive Encrypt service restarted!    -   Press any key to continue "
        ;;

    C)
        clear
        systemctl restart rclone
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
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo ""
        read -n 1 -s -r -p "RClone service restarted!   -   Press any key to continue "
        clear
        ;;

    D)
        clear
        systemctl restart rclone-en
        ## create log file if does not exist
        if [ -e "/opt/plexguide/rclone-en.log" ]
        then
            echo "Log exists"
        else
            touch /opt/plexguide/rclone-en.log
        fi

        ## obtains rclone-en.service info and puts into a log to be displayed to the user
        clear
        systemctl status rclone-en > /opt/plexguide/rclone-en.log
        cat /opt/plexguide/rclone-en.log
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo ""
        read -n 1 -s -r -p "RClone Encrypt service restarted!   -   Press any key to continue "
        clear
        ;;

    E)
        clear
        systemctl restart unionfs
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
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo ""
        read -n 1 -s -r -p "UnionFS service restarted!  -   Press any key to continue "
        clear
        ;;

    F)
        clear
        systemctl restart unionfs-encrypt
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
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo ""
        read -n 1 -s -r -p "UnionFS Encrypt service restarted!  -   Press any key to continue "
        clear
        ;;

    G)
        clear
        systemctl restart move
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
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo "Remember, there is a sleep function of 30 minutes after done"
        echo "If you have tons of stuff downloaded, you should see some activity"
        echo ""
        read -n 1 -s -r -p "Move service restarted! -   Press any key to continue "
        clear
        ;;

    H)
        clear
        systemctl restart move-en
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
        echo ""
        echo ""
        echo "*** View the Log ***"
        echo "Remember, there is a sleep function of 30 minutes after done"
        echo "If you have tons of stuff downloaded, you should see some activity"
        echo
        echo ""
        read -n 1 -s -r -p "Move Encrypt service restarted! -   Press any key to continue "
        clear
        ;;

     Z)
        clear
        exit 0 ;;

esac


### loops until exit
bash /opt/plexguide/menus/info-tshoot/info/restart-menu.sh
