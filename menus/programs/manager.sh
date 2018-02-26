#!/bin/bash

## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
echo $domain

HEIGHT=14
WIDTH=38
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Manager Programs"

OPTIONS=(A "Couchpotato"
         B "Lidarr"
         C "Medusa"
         D "Mylar"
         E "Radarr"
         F "Sickrage"
         G "Sonarr"
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
      program=couchpotato
      port=5050
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags couchpotato ;;

    B)
      clear
      program=lidarr
      port=8686
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lidarr ;;

    C)
      clear
      program=medusa
      port=8081
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa ;;

    D)
      clear
      program=mylar
      port=8090
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags mylar ;;

    E)
      clear
      program=radarr
      port=7878
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr ;;

    F)
      clear
      program=sickrage
      port=8082
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sickrage ;;

    G)
      clear
      program=sonarr
      port=8989
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr ;;

    Z)
      exit 0 ;;
esac
    clear

    dialog --title "$program - Address Info" \
    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/manager.sh
