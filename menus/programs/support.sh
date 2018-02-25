#!/bin/bash

## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

HEIGHT=16
WIDTH=45
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PlexGuide - Version 5.045"

OPTIONS=(A "NetData"
         B "OMBIv3"
         C "NextCloud"
         D "pyLoad"
         E "Resilio"
         F "Tautulli"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            $program="netdata"
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        B)
            bash /opt/plexguide/menus/plexdrive/rc-pd.sh ;;

        C)
            bash /opt/plexguide/menus/programs/main.sh ;;
        D)
            bash /opt/plexguide/scripts/menus/processor/processor-menu.sh ;;
        E)
            bash /opt/plexguide/scripts/menus/bench-menu.sh ;;
        F)
            bash /opt/plexguide/scripts/menus/help-select.sh ;;
        Z)
            clear
            echo "1. Please STAR PG via http://github.plexguide.com"
            echo "2. Join the PG Discord via http://discord.plexguide.com"
            echo "3. Donate to PG via http://donate.plexguide.com"
            echo ""
            echo "TIP: Restart the Program Anytime, type: plexguide"
            echo "TIP: Update Plexguide Anytime, type: pgupdate"
            echo "TIP: Press Z, then [ENTER] in the Menus to Exit"
            echo "TIP: Menu Letters Displayed are HotKeys"
            echo ""
            exit 0 ;;
esac

    clear
    echo "$program  - http://$ipv4:19999"
    echo "Subdomain - https://$program.$domain"
    echo "Domain    - http://$domain:19999"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "