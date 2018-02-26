 #!/bin/bash

 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

 HEIGHT=12
 WIDTH=38
 CHOICE_HEIGHT=6
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Manager Programs"

 OPTIONS=(A "Heimdall"
          B "HTPCManager"
          C "Muximux"
          D "Organizr"
          E "Wordpress"
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
      program=heimdall
      port=1111
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags heimdall ;;


    B)
      clear
      program=htpcmanager
      port=8085
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags htpcmanager ;;

    C)
      clear
      program=muximux
      port=8015
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags muximux;;

    D)
      clear
      program=organizr
      port=8020
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags organizr ;;

     E)
       clear
       program=wordpress
       port=NONE
       ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress ;;

     Z)
       exit 0 ;;
esac

    clear

    dialog --title "$program - Address Info" \
    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/ui.sh
