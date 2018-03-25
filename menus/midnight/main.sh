
 #!/bin/bash
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com

file="/var/plexguide/midnight.yes"
if [ -e "$file" ]
then
   exit
else
   dialog --title "Install Question" --msgbox "\nInstall Midnight Commander?\n\nAn easy way to see all your files!" 0 0
   touch /var/plexguide/midnight.yes
fi

HEIGHT=11
WIDTH=52
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Midgnith Commander - File Organizer"
MENU="Make Your Selection:"

OPTIONS=(A "Yes"
         B "No"
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
             apt-get update
             apt-get install mc
             dialog --title "Status" --msgbox "\nMidnight Commander is Installed!\n\nType - mc - to USE IT!" 0 0
             exit 0
            ;;
        B)
             dialog --title "Status" --msgbox "\nExit - Users Selected No" 0 0
             exit 0
            ;;
        Z)
            dialog --title "Status" --msgbox "\nExit - No Change Was Made" 0 0
            exit 0
            ;;
esac

bash /opt/plexguide/menus/midnight/main.sh
