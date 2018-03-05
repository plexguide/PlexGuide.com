#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

export NCURSES_NO_UTF8_ACS=1
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
       skip=yes
       ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress ;;
     Z)
       exit 0 ;;
esac

    clear

########## Deploy Start
number=$((1 + RANDOM % 2000))
echo "$number" > /tmp/number_var

if [ "$skip" == "yes" ]; then
    clear
else

    HEIGHT=9
    WIDTH=42
    CHOICE_HEIGHT=5
    BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
    TITLE="Schedule a Backup of --$program --?"

    OPTIONS=(A "Weekly"
             B "Daily"
             Z "None")

    CHOICE=$(dialog --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    case $CHOICE in
            A)
                clear
                echo "$program" > /tmp/program_var
                echo "weekly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy
                read -n 1 -s -r -p "Press any key to continue "
                --msgbox "\nBackups of -- $program -- will occur!" 0 0 ;;
            B)
                clear
                echo "$program" > /tmp/program_var
                echo "daily" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy
                read -n 1 -s -r -p "Press any key to continue "
                --msgbox "\nBackups of -- $program -- will occur!" 0 0 ;;
            Z)
                --msgbox "\nNo Daily Backups will Occur of -- $program --!" 0 0
                clear ;;
    esac
fi
########## Deploy End

dialog --title "$program - Address Info" \
--msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/ui.sh
