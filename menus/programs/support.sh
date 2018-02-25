#!/bin/bash

## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

HEIGHT=16
WIDTH=45
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Supporting"

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
            clear
            program=NetData
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        B)
            clear
            program=NetData
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        C)
            clear
            program=NetData
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        D)
            clear
            program=NetData
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        E)
            clear
            program=NetData
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        F)
            clear
            program=NetData
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        Z)
            exit 0 ;;
esac

    clear
    dialog --title "$program - Address Info" \
    --msgbox "\n$program   - http://$ipv4:19999\nSubdomain - https://$program.$domain\nDomain    - http://$domain:19999" 8 50