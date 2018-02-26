#!/bin/bash

## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

HEIGHT=13
WIDTH=38
CHOICE_HEIGHT=8
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
            port=19999
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata ;;
        B)
            clear
            program=ombi
            port=3579
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi ;;
        C)
            clear
            program=NextCloud
            port=4645
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags next ;;
        D)
            clear
            program=pyLoad
            port=8000
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pyLoad ;;
        E)
            clear
            program=Resilio
            port=8888
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags resilio ;;
        F)
            clear
            program=Tautulli
            port=8181
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli ;;
        Z)
            exit 0 ;;
esac

    clear
    dialog --title "$program - Address Info" \
    --msgbox "\nIPv4   - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/support.sh