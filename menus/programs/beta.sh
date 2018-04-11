 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1

 HEIGHT=10
 WIDTH=55
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "VPN Torrent"
          B "DO NOT USE - For Developers Use Only!"
          C "Use Local Storage - No GDrive Upload"
          D "Duplicati - Advanced Backup"
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
     D)
         display=Duplicati
         program=duplicati
         port=8200
         dialog --infobox "Installing: $display" 3 30
         ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags duplicati &>/dev/null &
         sleep 2
         cronskip="yes"
         ;;
     Z)
        clear
        exit 0 ;;
esac

bash /opt/plexguide/menus/programs/beta.sh
