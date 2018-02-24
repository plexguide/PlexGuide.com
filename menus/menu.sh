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

file="/var/plexguide/dep35.yes"
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

clear

HEIGHT=16
WIDTH=45
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PlexGuide - Version 5.044"

OPTIONS=(A "Donation Menu"
         B "RClone & PlexDrive"
         C "PG Application Suite (Programs)"
         D "Enhance Processor Performance"
         E "Network & Server Benchmarks"
         F "Info & Troubleshoot"
         G "Backup & Restore"
         H "Update (Read Changelog)"
         I "Uninstall PG"
         J "BETA: Uncapped Upload Speeds"
         K "BETA: Turn On/Off App Ports"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)
            bash /opt/plexguide/scripts/menus/donate-norm-menu.sh ;;
        B)
            bash /opt/plexguide/scripts/menus/rclone-pd-select.sh ;;
        C)
            bash /opt/plexguide/menus/programs/main.sh ;;
        D)
            bash /opt/plexguide/scripts/menus/processor/processor-menu.sh ;;
        E)
            bash /opt/plexguide/scripts/menus/bench-menu.sh ;;
        F)
            bash /opt/plexguide/scripts/menus/help-select.sh ;;
        G)
            bash /opt/plexguide/menus/backup-restore/main.sh ;;
        H)
            bash /opt/plexguide/scripts/docker-no/upgrade.sh
              echo Remember, restart by typing: plexguide
              exit 0;;
        I)
            bash /opt/plexguide/scripts/menus/uninstaller-main.sh ;;
        J)
            bash /opt/plexguide/scripts/menus/transfer/main.sh ;;
        K)
            bash /opt/plexguide/scripts/menus/ports/ports.sh ;;
        Z)
            clear
            exit 0 ;;
esac