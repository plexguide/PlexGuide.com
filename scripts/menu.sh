#!/bin/bash

### remove exit hold
#rm -r /var/plexguide/exit.yes 1>/dev/null 2>&1
echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
#sudo apt-get install whiptail -y 1>/dev/null 2>&1
### incase it's not installed prior
file="/usr/bin/dialog"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   clear
   echo "Installing Dialog"
   apt-get install dialog 1>/dev/null 2>&1
   export NCURSES_NO_UTF8_ACS=1
fi

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

file="/var/plexguide/dep37.yes"
if [ -e "$file" ]
then
   touch /var/plexguide/message.no
else
   bash /opt/plexguide/scripts/baseinstall/main.sh
fi

## starup Message

bash /opt/plexguide/menus/startup/message.sh

## Force Exit if Required
file="/var/plexguide/exit.yes"
if [ -e "$file" ]
then
   exit
fi

bash /opt/plexguide/menus/main.sh