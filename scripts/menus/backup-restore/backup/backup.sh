#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup Menu" --menu "Make your choice" 11 25 4 \
    "1)" "Nedata"  \
    "2)" "NZBGET"  \
    "3)" "Ombi"  \
    "4)" "Portainer"  \
    "5)" "Portainer"  \
    "6)" "Portainer"  \
    "7)" "Portainer"  \
    "8)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      echo ymlprogram netdata > /tmp/program_var.txt
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
