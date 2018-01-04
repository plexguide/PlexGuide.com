#!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
bash /opt/plexguide/scripts/docker-no/user.sh

# copying rclone config to user incase bonehead is not root
cp /root/.config/rclone/rclone.conf ~/.config/rclone/rclone.conf 1>/dev/null 2>&1


file="/var/plexguide/dep28.yes"
if [ -e "$file" ]
then
   clear
else
   bash /opt/plexguide/scripts/startup/dep.sh
fi

## ensure folders follow plexguide

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

whiptail --title "Support Message" --msgbox "Visit http://binance.plexguide.com to purchase crypto coins. Purchasing Ripple, Stellar, and Tron are the way to go. Any sign ups will help support future website server costs and possible prizes! I truly use the site myself!" 10 76

while [ 1 ]
do
CHOICE=$(
whiptail --title "Visit PlexGuide.com - v5.0022" --menu "Make your choice" 16 40 9 \
   "1)" "Donation Menu (Please Turn On)"   \
   "2)" "RClone & PlexDrive"  \
   "3)" "Programs" \
   "4)" "Server & Net Benchmarks" \
   "5)" "Info & Troubleshoot" \
   "6)" "Backup & Restore" \
   "7)" "PlexGuide: Update" \
   "8)" "PlexGuide: UnInstall" \
   "9)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
   "1)")
       clear
       bash /opt/plexguide/scripts/menus/donate-norm-menu.sh
       ;;

   "2)")
       clear
       bash /opt/plexguide/scripts/menus/rclone-pd-select.sh
       ;;

   "3)")
       clear
       bash /opt/plexguide/scripts/menus/programs/program-select.sh
       ;;

   "4)")
        clear
        bash /opt/plexguide/scripts/menus/bench-menu.sh
        ;;

   "5)")
       clear
       bash /opt/plexguide/scripts/menus/help-select.sh
       ;;

   "6)")
       clear
       bash /opt/plexguide/scripts/menus/back-restore-select.sh
       ;;

   "7)")
       bash /opt/plexguide/scripts/docker-no/upgrade.sh
       clear
       echo Remember, restart by typing: plexguide
       exit 0;;

   "8)")
       clear
       bash /opt/plexguide/scripts/menus/uninstaller-main.sh
       ;;

   "9)")
       clear
       echo Remember, restart by typing:  plexguide
       exit
       ;;
esac
done
exit
