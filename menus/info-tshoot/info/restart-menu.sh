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
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    B)
        clear
        systemctl restart rclone-en
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        ;;

    C)
      clear
      systemctl restart rclone
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    D)
      clear
      systemctl restart rclone-encrypt
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    E)
      clear
      systemctl restart unionfs
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      clear
        ;;

    F)
        clear
        systemctl restart unionfs-encrypt
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

    G)
        clear
        systemctl restart move
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

    H)
        clear
        systemctl restart move-en
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

     Z)
      clear
      exit 0 ;;

esac


### loops until exit
bash /opt/plexguide/menus/info-tshoot/info/restart-menu.sh
