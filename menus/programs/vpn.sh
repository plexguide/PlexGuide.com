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

 HEIGHT=10
 WIDTH=55
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "First click here to setup var files"
          B "DelugeVPN"
          C "RTorrentVPN"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

     A)
     ansible-playbook /opt/plexguide/ansible/config-vpn.yml --tags var-vpn
     echo "Your Variables have now been set."
     echo ""
     read -n 1 -s -r -p "Press any key to continue "
     bash /opt/plexguide/menus/programs/vpn.sh
  #      sleep 3
  #          echo "$program" > /tmp/program
  #          echo "$program" > /tmp/program_var
  #          echo "$port" > /tmp/port
  #          bash /opt/plexguide/menus/time/cron.sh
  #          bash /opt/plexguide/menus/programs/ending.sh
     ;;
     B)
       display=DelugeVPN
       program=delugevpn
       echo "$program" > /tmp/program_var
       dialog --infobox "Installing: $display" 3 30
       port=8112
       ansible-playbook /opt/plexguide/ansible/vpn.yml --tags delugevpn
       #&>/dev/null &
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
     ;;
     C)
       display=rTorrentVPN
       program=rutorrent
       program_extra=flood
       echo "$program" > /tmp/program_var
       echo "$program_extra" > /tmp/program_var_extra
       dialog --infobox "Installing: $display" 3 30
       port=9080
       port_extra=3000
       ansible-playbook /opt/plexguide/ansible/vpn.yml --tags rtorrentvpn
       #&>/dev/null &
        sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            echo "$program_extra" > /tmp/program_extra
            echo "$program_extra" > /tmp/program_var_extra
            echo "$port_extra" > /tmp/port_extra
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending_extra.sh
     ;;
     Z)
       exit 0 ;;

esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/vpn.sh
