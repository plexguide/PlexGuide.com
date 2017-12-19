
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
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
whiptail --title "SABNZBD NGINX" --menu "Make your choice" 10 25 3 \
    "1)" "SABNZBD - Stable"   \
    "2)" "SABNZBD - Beta"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      docker rm nginx-sabnzbd-beta
      docker rm nginx-sabnzbd
      clear
      echo ymlprogram nginx-sabnzbd > /opt/plexguide/tmp.txt
      echo ymldisplay NGINX SABNZBD >> /opt/plexguide/tmp.txt
      echo ymlport 8090 >> /opt/plexguide/tmp.txt
      bash /opt/plexguide/scripts/docker-no/program-installer.sh
      ;;

    "2)")
      docker rm nginx-sabnzbd
      docker rm nginx-sabnzbd-beta
      clear
      echo ymlprogram nginx-sabnzbd-beta > /opt/plexguide/tmp.txt
      echo ymldisplay NGINX SABNZBD Beta >> /opt/plexguide/tmp.txt
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
