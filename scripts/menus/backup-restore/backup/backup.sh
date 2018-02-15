#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup Menu" --menu "Make your choice" 15 25 8 \
    "1)" "Netdata"  \
    "2)" "NZBGET"  \
    "3)" "Ombi"  \
    "4)" "Plex"  \
    "5)" "Portainer"  \
    "6)" "Sonarr"  \
    "7)" "Radarr"  \
    "8)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      echo "netdata" > /tmp/program_var
      ;;

    #"2)")
        #echo ymlprogram nzbget > /opt/plexguide/tmp.txt
        #echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
        #bash /opt/plexguide/scripts/docker-no/backup-script.sh
        #;;

    #"3)")
      #echo ymlprogram legacy > /tmp/program_var.txt
      #bash /opt/plexguide/scripts/docker-no/backup-script.sh
      #;;

    "8)")
        clear
        exit 0
        ;;
esac
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
done
exit
