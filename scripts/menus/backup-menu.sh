#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup Menu" --menu "Make your choice" 20 25 11 \
    "1)" "OMBIv3"   \
    "2)" "NZBGet"  \
    "3)" "Plex"  \
    "4)" "SABNZBD"  \
    "5)" "Sonarr"  \
    "6)" "Radarr"  \
    "7)" "Emby"  \
    "8)" "PlexDrive"  \
    "9)" "Tautulli"  \
    "10)" "Jackett"  \
    "11)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
        echo ymlprogram ombiv3 > /opt/plexguide/tmp.txt
        echo ymldisplay OMBIV3 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/backup-script.sh
        ;;

    "2)")
        echo ymlprogram nzbget > /opt/plexguide/tmp.txt
        echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/backup-script.sh
        ;;

    "3)")
      echo ymlprogram plex > /opt/plexguide/tmp.txt
      echo ymldisplay PLEX >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

    "4)")
      echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
      echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

    "5)")
      echo ymlprogram sonarr > /opt/plexguide/tmp.txt
      echo ymldisplay SONARR >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

    "6)")
      echo ymlprogram radarr > /opt/plexguide/tmp.txt
      echo ymldisplay RADARR >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

    "7)")
      echo ymlprogram embyserver > /opt/plexguide/tmp.txt
      echo ymldisplay EMBY >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

      "8)")
      bash /opt/plexguide/scripts/docker-no/backup-script-plexdrive.sh
      clear
      ;;

    "9)")
      echo ymlprogram tautulli > /opt/plexguide/tmp.txt
      echo ymldisplay Tautulli >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

    "10)")
      echo ymlprogram jackett > /opt/plexguide/tmp.txt
      echo ymldisplay Jackett >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

    "11)")
        clear
        exit 0
        ;;
esac
done
exit
