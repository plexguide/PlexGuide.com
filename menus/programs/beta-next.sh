 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1

 ## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
domain=$( cat /var/plexguide/server.domain )

 HEIGHT=10
 WIDTH=55
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "VPN Torrent - New way"
          B "VPN Torrent - Old way"
          C "DO NOT USE - For Developers Use Only!"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in
     A)
        bash /opt/plexguide/menus/programs/vpn-next.sh ;;
     B)
        bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh ;;
     C)
     clear
     bash /opt/plexguide/scripts/test/move.sh
     echo "Testing files have now been swapped"
     echo "Please go back to the main menu to see changes"
     read -n 1 -s -r -p "Press any key to continue "
     ;;

     Z)
        clear
        exit 0 ;;
esac

#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#### Recall Loop
bash /opt/plexguide/menus/programs/beta.sh
