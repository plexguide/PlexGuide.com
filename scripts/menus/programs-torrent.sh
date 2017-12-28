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
whiptail --title "Install Menu" --menu "Make your choice" 15 26 8 \
    "1)" "RuTorrent - Test"  \
    "2)" "Deluge - Test"  \
    "3)" "VPN Torrent - Test"  \
    "4)" "Jackett - Test"  \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

     "1)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rutorrent
      echo "RuTorrent: http://ipv4:8999 | For NGINX Proxy rutorrent.domain.com"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "2)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deluge
      echo "Deluge: http://ipv4:8112 | For NGINX Proxy deluge.domain.com"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

      "3)")
       clear
       bash /opt/plexguide/scripts/menus/torrentvpn-menu.sh
       ;;

     "4)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags jackett
      echo "Jackett: http://ipv4:9117 | For NGINX Proxy jackett.domain.com"
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "5)")
      clear
      exit 0
      ;;
esac
done
exit
