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
whiptail --title "Program Categories" --menu "Make your choice" 12 34 5 \
    "1)" "Netdata"   \
    "2)" "OMBIv3"   \
    "3)" "Resilio"  \
    "4)" "Tautulli"  \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata
    echo "NetData: http://ipv4:19999 | For NGINX Proxy netdata.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi
    echo "Ombi: http://ipv4:3579 | For NGINX Proxy ombi.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
     ;;

    "3)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags resilio
    echo "Resilio: http://ipv4:8888 | For NGINX Proxy resilio.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "4)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli
    echo "Tautulli: http://ipv4:8181 | For NGINX Proxy tautulli.domain.com"
    echo ""
    read -n 1 -s -r -p "Press any key to continue "
    ;;

     "5)")
      clear
      exit 0
      ;;
esac
done
exit
