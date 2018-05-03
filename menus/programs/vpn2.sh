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
 # This takes .yml file and converts it to bash readable format
 sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var-vpn.yml > /opt/appdata/plexguide/var-vpn.sh

 ## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
domain=$( cat /var/plexguide/server.domain )

 HEIGHT=11
 WIDTH=55
 CHOICE_HEIGHT=5
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "First click here to setup var files"
          B "DelugeVPN"
          C "RTorrentVPN"
          D "x2go Server"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

     A)
     skip=yes
     ansible-playbook /opt/plexguide/ansible/config-vpn.yml --tags var-vpn
     echo "Your Variables have now been set."
     echo
     read -n 1 -s -r -p "Press any key to continue "
     bash /opt/plexguide/menus/programs/vpn.sh
     ;;

     B)
     clear
     program=delugevpn
     port=8112
     ansible-playbook /opt/plexguide/ansible/vpn.yml --tags delugevpn 
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
     ;;

     C)
     clear
     program=rtorrentvpn
     port=3000
     ansible-playbook /opt/plexguide/ansible/vpn.yml --tags rtorrentvpn
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
     ;;
     
     D)
     clear
     program=x2go
     port=2222
     skip=yes
     rm -r ~/docker-x2go
     bash /opt/plexguide/scripts/test/x2go/x2go.sh
     #ansible-playbook /opt/plexguide/ansible/vpn.yml --tags x2go
     read -n 1 -s -r -p "Press any key to continue "
     ;;

     Z)
       exit 0 ;;

esac

clear

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/vpn.sh
