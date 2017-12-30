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
whiptail --title "Install Menu" --menu "Make your choice" 19 50 12 \
    "1)" "Force PreInstaller"   \
    "2)" "Reinstall Portainer"  \
    "3)" "Uninstall Docker & Containers (Force Preinstall)"  \
    "4)" "NZBGET"  \
    "5)" "Muximux"  \
    "6)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
   "1)")
      clear
      rm -r /var/plexguide/dep*
      echo
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "2)")
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer
      echo "NZBHydra: http://ipv4:5075 | For NGINX Proxy nzbhyra.domain.com"
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "3)")
      echo "Uninstall Docker"
      echo 
      apt-get purge docker-ce
      rm -rf /var/lib/docker
      clear
      read -n 1 -s -r -p "Docker Uninstalled - All Containers Removed"
      rm -r /var/plexguide/dep*
      clear
      echo ""
      echo "*** Exit This Menu / Select / Update, then Restart PlexGuide! ***"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;

     "4)")
      clear
      exit 0
      ;;
esac
done
exit
