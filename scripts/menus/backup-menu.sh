 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
bash /opt/plexguide/scripts/docker-no/user.sh

file="/var/plexguide/dep19.yes"
if [ -e "$file" ]
then
    clear
else
    bash /opt/plexguide/scripts/startup/dep.sh
    touch /var/plexguide/dep19.yes
fi

## ensure folders follow plexguide
bash /opt/plexguide/scripts/startup/owner.sh
chown -R plexguide:1000 /opt/plexguide/scripts/docker-no/*

##clear screen
clear

function contextSwitch {
    {
    ctxt1=$(grep ctxt /proc/stat | awk '{print $2}')
        echo 50
    sleep 1
        ctxt2=$(grep ctxt /proc/stat | awk '{print $2}')
        ctxt=$(($ctxt2 - $ctxt1))
        result="Number os context switches in the last secound: $ctxt"
    echo $result > result
    } | whiptail --gauge "Getting data ..." 6 60 0
}


function userKernelMode {
    {
    raw=( $(grep "cpu " /proc/stat) )
        userfirst=$((${raw[1]} + ${raw[2]}))
        kernelfirst=${raw[3]}
    echo 50
        sleep 1
    raw=( $(grep "cpu " /proc/stat) )
        user=$(( $((${raw[1]} + ${raw[2]})) - $userfirst ))
    echo 90
        kernel=$(( ${raw[3]} - $kernelfirst ))
        sum=$(($kernel + $user))
        result="Percentage of last sekund in usermode: \
        $((( $user*100)/$sum ))% \
        \nand in kernelmode: $((($kernel*100)/$sum ))%"
    echo $result > result
    echo 100
    } | whiptail --gauge "Getting data ..." 6 60 0
}

function interupts {
    {
    ints=$(vmstat 1 2 | tail -1 | awk '{print $11}')
        result="Number of interupts in the last secound:  $ints"
    echo 100
    echo $result > result
    } | whiptail --gauge "Getting data ..." 6 60 50
}

while [ 1 ]
do
CHOICE=$(
whiptail --title "Backup Menu" --menu "Make your choice" 15 23 8 \
    "1)" "OMBIv3"   \
    "2)" "NZBGet"  \
    "3)" "Plex"  \
    "4)" "SABNZBD"  \
    "5)" "Sonarr"  \
    "6)" "Radarr"  \
    "7)" "Emby"  \
    "8)" "PlexDrive"  \
    "9)" "Exit  "  3>&2 2>&1 1>&3
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
      echo ymlprogram emby > /opt/plexguide/tmp.txt
      echo ymldisplay EMBY >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/backup-script.sh
      ;;

      "8)")
      bash /opt/plexguide/scripts/docker-no/backup-script-plexdrive.sh
      clear
      ;;

    "9)")
        clear
        exit 0
        ;;
esac
done
exit
