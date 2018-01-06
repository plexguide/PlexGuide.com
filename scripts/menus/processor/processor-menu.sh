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

################# Virtual Machine Check
if (whiptail --title "Virutal Machine Question" --yesno "Are You Utilizing A Virtual Machine?" 8 65) then

    whiptail --title "Virutal Machine - Yes" --msgbox "We are unable to adjust your CPU performance while utilizing a virtual machine. Trust me, it does not work if you try!" 9 65
    exit 
else
    whiptail --title "Virutal Machine - No" --msgbox "We will now ask you if you want to enhance your cpu - processor performance. We recommend that you utilize performance mode!" 9 65
fi


while [ 1 ]
do
CHOICE=$(
whiptail --title "Processor Performance" --menu "Make your choice" 11 60 5 \
    "1)" "Peformance Mode   - Recommend for Top Performance"  \
    "2)" "Ondemand Mode     - Default Mode"  \
    "3)" "Conservative Mode - Utilizes Less Power (Slowest)"  \
    "4)" "View Current Processor Policy"  \
    "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    ansible-playbook /opt/plexguide/ansible/roles/processor/processor.yml --tags performance 
    ;;

    "2)")
    clear
    ansible-playbook /opt/plexguide/ansible/roles/processor/processor.yml --tags ondemand
    ;;

    "3)")
    clear
    ansible-playbook /opt/plexguide/ansible/roles/processor/processor.yml --tags conservative
    ;;

    "4)")
    clear
    cpufreq-info
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
