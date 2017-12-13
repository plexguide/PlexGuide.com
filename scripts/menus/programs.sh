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
whiptail --title "Restore Menu" --menu "Make your choice" 20 21 13 \
    "1)" "Plex"   \
    "2)" "Emby"  \
    "3)" "Netdata"  \
    "4)" "NZBGET"  \
    "5)" "Muximux"  \
    "6)" "OMBIv3"  \
    "7)" "Organizr"  \
    "8)" "PlexPy"  \
    "9)" "Radarr"  \
    "10)" "SABNZBD"  \
    "11)" "Sonarr"  \
    "12)" "Wordpress"  \
    "13)" "Exit  "  3>&2 2>&1 1>&3   
)

result=$(whoami)
case $CHOICE in
    "1)")   
     clear
     bash /opt/plexguide/scripts/menus/plexsub-menu.sh
     ;;

    "2)")   
      echo ymlprogram emby > /opt/plexguide/tmp.txt
      echo ymldisplay Emby >> /opt/plexguide/tmp.txt
      echo ymlport 8096 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "3)")   
     echo ymlprogram netdata > /opt/plexguide/tmp.txt
     echo ymldisplay NetData >> /opt/plexguide/tmp.txt
     echo ymlport 19999 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "4)")   
     echo ymlprogram nzbget > /opt/plexguide/tmp.txt
     echo ymldisplay NZBGET >> /opt/plexguide/tmp.txt
     echo ymlport 6789 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "5)")   
     echo ymlprogram muximux > /opt/plexguide/tmp.txt
     echo ymldisplay Muximux >> /opt/plexguide/tmp.txt
     echo ymlport 8015 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "6)")   
     echo ymlprogram ombi > /opt/plexguide/tmp.txt
     echo ymldisplay Ombi >> /opt/plexguide/tmp.txt
     echo ymlport 3579 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "7)")   
     echo ymlprogram organizr > /opt/plexguide/tmp.txt
     echo ymldisplay Organizr >> /opt/plexguide/tmp.txt
     echo ymlport 8020 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "8)")   
     echo ymlprogram plexpy > /opt/plexguide/tmp.txt
     echo ymldisplay PlexPY >> /opt/plexguide/tmp.txt
     echo ymlport 8181 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "9)")   
     echo ymlprogram radarr > /opt/plexguide/tmp.txt
     echo ymldisplay Radarr >> /opt/plexguide/tmp.txt
     echo ymlport 7878 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "10)")   
     echo ymlprogram sabnzbd > /opt/plexguide/tmp.txt
     echo ymldisplay SABNZBD >> /opt/plexguide/tmp.txt
     echo ymlport 8090 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "11)")   
     echo ymlprogram sonarr > /opt/plexguide/tmp.txt
     echo ymldisplay Sonarr >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "12)")   
     echo ymlprogram sonarr > /opt/plexguide/tmp.txt
     echo ymldisplay Sonarr >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "13)") 
        clear
        exit 0
        ;;
esac
done
exit