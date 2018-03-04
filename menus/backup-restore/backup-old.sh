#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup Menu" --menu "Make your choice" 19 25 12 \
    "1 )" "CouchPotato"  \
    "2 )" "Deluge"  \
    "3 )" "Emby"  \
    "4 )" "Heimdall"  \
    "5 )" "HTPCManager"  \
    "6 )" "Jackett"  \
    "7 )" "Lidarr"  \
    "8 )" "Medusa"  \
    "9 )" "Myler"  \
    "10)" "Muximux"  \
    "11)" "NZBGET"  \
    "12)" "NZBHydra"  \
    "13)" "NZBHydra2"  \
    "14)" "Ombi"  \
    "15)" "Organizr"  \
    "16)" "Plex"  \
    "17)" "Portainer"  \
    "18)" "Radarr"  \
    "19)" "Resilio"  \
    "20)" "Rutorret"  \
    "21)" "SABNZBD"  \
    "22)" "Sonarr"  \
    "23)" "Tautulli"  \
    "24)" "Ubooquity"  \
    "25)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1 )")
      echo "couchpotato" > /tmp/program_var
      ;;

    "2 )")
      echo "deluge" > /tmp/program_var
      ;;

    "3 )")
      echo "embyserver" > /tmp/program_var
      ;;

    "4 )")
      echo "heimdall" > /tmp/program_var
      ;;

    "5 )")
      echo "htpcmanager" > /tmp/program_var
      ;;

    "6 )")
      echo "jackett" > /tmp/program_var
      ;;

    "7 )")
      echo "lidarr" > /tmp/program_var
      ;;

    "8 )")
      echo "medusa" > /tmp/program_var
      ;;

    "9 )")
      echo "myler" > /tmp/program_var
      ;;

    "10)")
      echo "muximux" > /tmp/program_var
      ;;

    "11)")
      echo "nzbget" > /tmp/program_var
      ;;

    "12)")
      echo "nzbhydra" > /tmp/program_var
      ;;

    "13)")
      echo "nzbhydra2" > /tmp/program_var
      ;;

    "14)")
      echo "ombiv3" > /tmp/program_var
      ;;

    "15)")
      echo "organizr" > /tmp/program_var
      ;;

    "16)")
      echo "plex" > /tmp/program_var
      ;;

    "17)")
      echo "portainer" > /tmp/program_var
      ;;

    "18)")
      echo "radarr" > /tmp/program_var
      ;;

    "19)")
      echo "resilio" > /tmp/program_var
      ;;

    "20)")
      echo "rutorrent" > /tmp/program_var
      ;;

    "21)")
      echo "sabnzbd" > /tmp/program_var
      ;;

    "22)")
      echo "sonarr" > /tmp/program_var
      ;;

    "23)")
      echo "tautulli" > /tmp/program_var
      ;;

    "24)")
      echo "ubooquity" > /tmp/program_var
      ;;

    "25)")
        clear
        exit 0
        ;;
esac
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
read -n 1 -s -r -p "Press any key to continue "
done
exit
