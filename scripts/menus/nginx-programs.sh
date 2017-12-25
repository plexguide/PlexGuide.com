 #!/bin/bash

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
whiptail --title "Install Menu" --menu "Make your choice" 22 35 15 \
    "1)" "NGINX - Required First"  \
    "2)" "Plex"   \
    "3)" "Emby"  \
    "4)" "Netdata"  \
    "5)" "NZBGET"  \
    "6)" "Muximux"  \
    "7)" "OMBIv3"  \
    "8)" "Organizr"  \
    "9)" "Tautulli"  \
    "10)" "Radarr"  \
    "11)" "SABNZBD"  \
    "12)" "Sonarr"  \
    "13)" "Not Ready - Wordpress"  \
    "14)" "Apache"  \
    "15)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
     echo ymlprogram nginx-proxy > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Proxy >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "2)")
      sudo docker stop plexpublic 1>/dev/null 2>&1
      sudo docker rm plexpublic 1>/dev/null 2>&1
      echo ymlprogram nginx-plexpublic > /opt/plexguide/tmp.txt
      echo ymldisplay NGINX Plex Public >> /opt/plexguide/tmp.txt
      echo ymlport 32400 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "3)")
      sudo docker stop emby 1>/dev/null 2>&1
      sudo docker rm emby 1>/dev/null 2>&1
      echo ymlprogram nginx-emby > /opt/plexguide/tmp.txt
      echo ymldisplay NGINX Emby >> /opt/plexguide/tmp.txt
      echo ymlport 8096 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "4)")
     sudo docker stop netdata 1>/dev/null 2>&1
     sudo docker rm netdata 1>/dev/null 2>&1
     echo ymlprogram nginx-netdata > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX NetData >> /opt/plexguide/tmp.txt
     echo ymlport 19999 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "5)")
     sudo docker stop nzbget 1>/dev/null 2>&1
     sudo docker rm nzbget 1>/dev/null 2>&1
     echo ymlprogram nginx-nzbget > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX NZBGET >> /opt/plexguide/tmp.txt
     echo ymlport 6789 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "6)")
     sudo docker stop muximux 1>/dev/null 2>&1
     sudo docker rm muximux 1>/dev/null 2>&1
     echo ymlprogram nginx-muximux > /opt/plexguide/tmp.txt
     echo ymldisplay Muximux >> /opt/plexguide/tmp.txt
     echo ymlport 8015 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "7)")
     sudo docker stop ombi 1>/dev/null 2>&1
     sudo docker rm ombi 1>/dev/null 2>&1
     echo ymlprogram nginx-ombi > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Ombi >> /opt/plexguide/tmp.txt
     echo ymlport 3579 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "8)")
     sudo docker stop organizr 1>/dev/null 2>&1
     sudo docker rm organizr 1>/dev/null 2>&1
     echo ymlprogram nginx-organizr > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Organizr >> /opt/plexguide/tmp.txt
     echo ymlport 8020 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "9)")
     sudo docker stop tautulli 1>/dev/null 2>&1
     sudo docker rm tautulli 1>/dev/null 2>&1
     echo ymlprogram nginx-tautulli > /opt/plexguide/tmp.txt
     echo ymldisplay Tautulli >> /opt/plexguide/tmp.txt
     echo ymlport 8181 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "10)")
     sudo docker stop radarr 1>/dev/null 2>&1
     sudo docker rm radarr 1>/dev/null 2>&1
     echo ymlprogram nginx-radarr > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Radarr >> /opt/plexguide/tmp.txt
     echo ymlport 7878 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "11)")
     clear
     bash /opt/plexguide/scripts/menus/sabsub-nginx-menu.sh
     ;;

    "12)")
     sudo docker stop sonarr 1>/dev/null 2>&1
     sudo docker rm sonarr 1>/dev/null 2>&1
     echo ymlprogram nginx-sonarr > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Sonarr >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "13)")
     echo ymlprogram nginx-wordpress > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Wordpress >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "14)")
     echo ymlprogram nginx-apache > /opt/plexguide/tmp.txt
     echo ymldisplay NGINX Apache >> /opt/plexguide/tmp.txt
     echo ymlport 80 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "15)")
        clear
        exit 0
        ;;
esac
done
exit
