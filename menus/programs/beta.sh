 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1

 HEIGHT=11
 WIDTH=55
 CHOICE_HEIGHT=5
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "VPN Torrent"
          B "DO NOT USE - For Developers Use Only!"
          C "Duplicati - Advanced Backup"
          D "PLEXTEST"
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
         display=Duplicati
         dialog --infobox "Installing: $display" 3 30
         ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags duplicati &>/dev/null &
         sleep 2
         dialog --msgbox 'Duplicati access: domain.com:8200 Remember to set password' 8 30
         cronskip="yes"
         ;;

     D)
     bash /opt/plexguide/menus/plex/test.sh ;;
     Z)
        clear
        exit 0 ;;
esac

bash /opt/plexguide/menus/programs/beta.sh
