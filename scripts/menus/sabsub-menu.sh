
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "SABNZBD Install" --menu "Make your choice" 10 25 3 \
    "1)" "SABNZBD - Stable"   \
    "2)" "SABNZBD - Beta"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      docker rm sabnzbd-beta
      docker rm sabnzbd
      clear
      echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
      echo ymlport 8090 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "2)")
      docker rm sabnzbd
      docker rm sabnzbd-beta
      clear
      echo ymlprogram sabnzbd-beta > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD Beta >> /opt/plexguide/tmp.txt
      echo ymlport 8090 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
