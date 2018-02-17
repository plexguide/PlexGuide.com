#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Restore Menu" --menu "Make your choice" 19 25 12 \
    "1 )" "CouchPotato"  \
    "2 )" "Deluge"  \
    "3 )" "Emby"  \
    "4 )" "Heimdall"  \
    "5 )" "HTPCManager"  \
    "6 )" "Jackett"  \
    "7 )" "Lidarr"  \
    "8 )" "Medusa"  \
    "9)" "Myler"  \
    "10)" "Muximux"  \
    "11)" "NZBGET"  \
    "12)" "NZBHydra"  \
    "13)" "NZBHydra"  \
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
      echo "emby" > /tmp/program_var
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
      echo "nzbhyra2" > /tmp/program_var
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
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags restore
read -n 1 -s -r -p "Press any key to continue "
done
exit
