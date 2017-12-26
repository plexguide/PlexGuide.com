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
whiptail --title "Install Menu" --menu "Make your choice" 19 32 12 \
    "1)" "Plex"   \
    "2)" "Emby"  \
    "3)" "Netdata"  \
    "4)" "NZBGET"  \
    "5)" "Muximux"  \
    "6)" "OMBIv3"  \
    "7)" "Organizr"  \
    "8)" "Radarr"  \
    "9)" "SABNZBD"  \
    "10)" "Sonarr"  \
    "11)" "Tautulli"  \
    "12)" "Wordpress"  \
    "13)" "Mylar - Test"  \
    "14)" "Headphones - Test"  \
    "15)" "Ubooquity - Test"  \
    "16)" "Exit  "  3>&2 2>&1 1>&3
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
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata
    echo "NetData: http://ipv4:19999 | For NGINX Proxy netdata.domain.com"
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "4)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nzbget
    echo "NetData: http://ipv4:6789 | For NGINX Proxy nzbget.domain.com"
    read -n 1 -s -r -p "Press any key to continue "
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
     echo ymlprogram radarr > /opt/plexguide/tmp.txt
     echo ymldisplay Radarr >> /opt/plexguide/tmp.txt
     echo ymlport 7878 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "9)")
     clear
     bash /opt/plexguide/scripts/menus/sabsub-menu.sh
     ;;

    "10)")
     echo ymlprogram sonarr > /opt/plexguide/tmp.txt
     echo ymldisplay Sonarr >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

    "11)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli
    echo "NetData: http://ipv4:8181 | For NGINX Proxy tautulli.domain.com"
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "12)")
     echo ymlprogram wordpress > /opt/plexguide/tmp.txt
     echo ymldisplay Wordpress >> /opt/plexguide/tmp.txt
     echo ymlport 8989 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

     "13)")
     echo ymlprogram mylar > /opt/plexguide/tmp.txt
     echo ymldisplay MYLAR >> /opt/plexguide/tmp.txt
     echo ymlport 8099 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

     "14)")
     echo ymlprogram headphones > /opt/plexguide/tmp.txt
     echo ymldisplay HeadPhones >> /opt/plexguide/tmp.txt
     echo ymlport 8282 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

     "15)")
     echo ymlprogram ubooquity > /opt/plexguide/tmp.txt
     echo ymldisplay Ubooquity >> /opt/plexguide/tmp.txt
     echo ymlport 2203 >> /opt/plexguide/tmp.txt
     bash /opt/plexguide/scripts/docker-no/program-installer.sh
     ;;

     "16)")
      clear
      exit 0
      ;;
esac
done
exit
