
 #!/bin/bash

export NCURSES_NO_UTF8_ACS=1
## point to variable file for ipv4 and domain.com

HEIGHT=10
WIDTH=43
CHOICE_HEIGHT=3
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Server Security"
MENU="Make a Selection:"

OPTIONS=(A "APP Ports - [OPEN]"
         B "APP Protection Guard - [OFF]"
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
          bash /opt/plexguide/menus/ports/main.sh ;;
        B)
          ;;
        Z)
            clear
            exit 0
            ;;
esac

bash /opt/plexguide/menus/security/main.sh
