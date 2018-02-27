#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Detique
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
 echo $domain

 HEIGHT=9
 WIDTH=55
 CHOICE_HEIGHT=3
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "First click here to setup var files"
          B "DelugeVPN"
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
        bash /opt/plexguide/menus/programs/vpn.sh ;;
     B)
        clear
        program=delugevpn
        port=8112
        ansible-playbook /opt/plexguide/ansible/vpn.yml --tags delugevpn ;;
     Z)
        clear
        exit 0 ;;
esac

    clear
    dialog --title "$program - Address Info" \
    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/vpn.sh
