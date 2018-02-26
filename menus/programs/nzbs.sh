 #!/bin/bash

## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

HEIGHT=13
WIDTH=38
CHOICE_HEIGHT=8
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="NZB Applications - PG Supporting"

OPTIONS=(A "NZBGet"
         B "NZBHydra"
         C "NZBHydra2"
         D "SABNZBD"

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            clear
            program=NZBGet
            port=19999
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbget ;;
        B)
            clear
            program=NZBHydra
            port=5075
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbhydra ;;
        C)
            clear
            program=NZBHydra2
            port=5076
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbhydra2 ;;
        D)
            clear
            program=SABNZBD
            port=9000
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags SABNZBD ;;

        Z)
            exit 0 ;;
esac

    clear
    
    dialog --title "$program - Address Info" \
    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/nzbs.sh.sh
