#!/bin/bash

### remove exit hold
#rm -r /var/plexguide/exit.yes 1>/dev/null 2>&1

#check to see if /var/plexguide/dep exists - if not, install dependencies
bash /opt/plexguide/scripts/docker-no/user.sh

# copying rclone config to user incase bonehead is not root
cp /root/.config/rclone/rclone.conf ~/.config/rclone/rclone.conf 1>/dev/null 2>&1

# Checking to see if VNC Container is Running
file="/var/plexguide/vnc.yes"
if [ -e "$file" ]
then
whiptail --title "Warning" --msgbox "You still have the VNC Container Running! Make sure to Destroy the Container via the VNC Menu!" 9 66
fi

file="/var/plexguide/dep33.yes"
if [ -e "$file" ]
then
   touch /var/plexguide/message.no
else
   bash /opt/plexguide/scripts/startup/dep.sh
fi

## starup Message

  bash /opt/plexguide/scripts/docker-no/random.sh

## Force Exit if Required
file="/var/plexguide/exit.yes"
if [ -e "$file" ]
then
   exit
fi

while [ 1 ]
do
CHOICE=$(
whiptail --title "Visit PlexGuide.com - v5.040" --menu "Make your choice" 18 43 11 \
   "1)" "Donation Menu (Please Turn On)" \
   "2)" "RClone & PlexDrive" \
   "3)" "Programs" \
   "4)" "Set Processor Performance" \
   "5)" "Server & Net Benchmarks" \
   "6)" "VNC Remote Server Install" \
   "7)" "Info & Troubleshoot" \
   "8)" "Backup & Restore" \
   "9)" "PlexGuide: Update (Check ChangeLog)" \
   "10)" "PlexGuide: UnInstall" \
   "11)" "Exit  "  3>&2 2>&1 1>&3
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
       bash /opt/plexguide/scripts/menus/processor/processor-menu.sh
       ;;

   "5)")
        clear
        bash /opt/plexguide/scripts/menus/bench-menu.sh
        ;;

   "6)")
       clear
       bash /opt/plexguide/scripts/menus/vnc.sh
       ;;

   "7)")
       clear
       bash /opt/plexguide/scripts/menus/help-select.sh
       ;;

   "8)")
       clear
       bash /opt/plexguide/scripts/menus/backup-restore/main.sh
       ;;

   "9)")
       bash /opt/plexguide/scripts/docker-no/upgrade.sh
       clear
       echo Remember, restart by typing: plexguide
       exit 0;;

   "10)")
       clear
       bash /opt/plexguide/scripts/menus/uninstaller-main.sh
       ;;

   "11)")
       clear
       echo Remember, restart by typing:  plexguide
       exit
       ;;
esac
done
exit
