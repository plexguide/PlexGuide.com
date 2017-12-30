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
whiptail --title "Information Menu" --menu "Make your choice" 14 34 7 \
    "1)" "View HardDrive Space"   \
    "2)" "View Container Info"  \
    "3)" "Verify PlexDrive"  \
    "4)" "Verify UnionFS"  \
    "5)" "Verify UN-RClone"  \
    "6)" "Verify EN-RClone"  \
#    "7)" "System Info and Bench"  \
    "7)" "Benchmark and Info"  \
    "8)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      clear
      df -h --total
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      ;;

    "2)")
        clear
        ctop
        ;;

    "3)")
      clear
      ls /mnt/plexdrive4
      echo
      echo "*** PlexDrive4: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: Must have at least 1 item in your Google Drive for the test"
      echo "Note 2: Once you finish the PLEXDRIVE4 setup, you'll see everything!"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "4)")
      touch /mnt/move/uniontest.txt
      clear
      ls /mnt/unionfs
      echo
      echo "*** UnionFS: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see uniontest.txt"
      echo "Note 2: Once PLEXDRIVE4 is setup, you should see the rest"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
      ;;

    "5)")
      touch /mnnt/gdrive/gdrivetest.txt
      clear
      ls /mnt/gdrive
      echo
      echo "*** RClone: Your Google Drive - If empty, that's not good ***"
      echo "Note 1: You should at least see gdrivetest.txt"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      clear
        ;;

    "6)")
        touch /mnt/.gcrypt/gdrivetest.txt
        clear
        ls /mnt/.gcrypt
        echo
        echo "*** RClone: Your Google Drive - If empty, that's not good ***"
        echo "Note 1: You should at least see gdrivetest.txt"
        echo
        read -n 1 -s -r -p "Press any key to continue "
        clear
        ;;

#      "7)")
#      echo "Do you want to run benchmark and information? (y/n)? "
#      old_stty_cfg=$(stty -g)
#      stty raw -echo
#      answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
#      stty $old_stty_cfg
#      if echo "$answer" | grep -iq "^y" ;then
#          echo Yes;
#
#      sudo wget -qO- bench.sh | bash
#
#    else
#        echo No
#        clear
#        echo "Did not run benchmark and information"
#        echo
#    fi
#
#    read -n 1 -s -r -p "Press any key to continue "
#    clear
#    ;;

  "7)")
  clear
  bash /opt/plexguide/scripts/menus/bench-menu.sh
  ;;

     "8)")
      clear
      exit 0
      ;;
esac
done
exit
