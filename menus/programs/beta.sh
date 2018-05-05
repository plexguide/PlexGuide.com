 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1

 HEIGHT=11
 WIDTH=55
 CHOICE_HEIGHT=5
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "DO NOT USE - For Developers Use Only!"
          B "Duplicati - Advanced Backup"
          C "PLEXTEST"
          D "RClone Cache Unencrypted"
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
     clear
     bash /opt/plexguide/scripts/test/move.sh
     echo "Testing files have now been swapped"
     echo "Please go back to the main menu to see changes"
     read -n 1 -s -r -p "Press any key to continue "
     ;;
     B)
         display=Duplicati
         dialog --infobox "Installing: $display" 3 30
         ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags duplicati &>/dev/null &
         sleep 2
         dialog --msgbox 'Duplicati access: domain.com:8200 Remember to set password' 8 30
         cronskip="yes"
         ;;

     C)
     bash /opt/plexguide/menus/plex/test.sh ;;
     D)
    bash /opt/plexguide/menus/rclone/uncache.sh ;;
     Z)
        clear
        exit 0 ;;
esac

bash /opt/plexguide/menus/programs/beta.sh
