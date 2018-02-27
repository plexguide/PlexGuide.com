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

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Torrent VPN Menu" --menu "Make your choice" 12 50 5 \
    "1)" "First click here to setup var files"  \
    "2)" "RTorrentVPN"  \
    "3)" "DelugeVPN"  \
    "4)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

     "1)")
     ansible-playbook /opt/plexguide/ansible/config-vpn.yml --tags var-vpn
     echo "Your Variables have now been set."
     echo ""
     read -n 1 -s -r -p "Press any key to continue "
     bash /opt/plexguide/menus/programs/vpn-old.sh
     ;;

     "2)")
      ansible-playbook /opt/plexguide/ansible/vpn.yml --tags rtorrentvpn
      echo "RTorrentVPN: http://$ipv4:3000"
      echo "For Subdomain https://rtorrentvpn.$domain"
      echo "For Domain http://$domain:3000"
      echo ""
      echo "Please set your own username & password!"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "3)")
      ansible-playbook /opt/plexguide/ansible/vpn.yml --tags delugevpn
      echo "DelugeVPN: http://$ipv4:8112"
      echo "For Subdomain https://delugevpn.$domain"
      echo "For Domain http://$domain:8112"
      echo ""
      echo "Default password: deluge"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "4)")
      clear
      exit 0
      ;;
esac
done
exit
