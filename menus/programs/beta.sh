 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1

 ## point to variable file for ipv4 and domain.com
# source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
# echo $ipv4
# echo $domain

 HEIGHT=10
 WIDTH=55
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "VPN Torrent"
          B "DO NOT USE - For Developers Use Only!"
          C " Use Local Storage - No GDrive Upload"
          Z "Exit")

 CHOICE=$(dialog --clear \
                 --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in
     A)
        bash /opt/plexguide/menus/programs/vpn.sh ;;
     B)
     clear
     bash /opt/plexguide/scripts/test/move.sh
     echo "Testing files have now been swapped"
     echo "Please go back to the main menu to see changes"
     read -n 1 -s -r -p "Press any key to continue "
     ;;
     C)
     bash /opt/plexguide/menus/programs/localstorage.sh ;;
     Z)
        clear
        exit 0 ;;
esac

#    clear
#    dialog --title "$program - Address Info" \
#    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
# bash /opt/plexguide/menus/programs/beta.sh
