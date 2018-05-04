#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

#### Set Fixed Information
bash /opt/plexguide/info.sh

#### Temp Variables Established To Prevent Crashing - START
echo "plexguide" > /tmp/pushover
#### Temp Variables Esablished  To Prevent Crashing - END

echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
mkdir /var/plexguide/ 1>/dev/null 2>&1

file="/usr/bin/dialog"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   clear
   echo "Installing Dialog"
   apt-get install dialog 1>/dev/null 2>&1
   export NCURSES_NO_UTF8_ACS=1
   echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
fi
# install pgstatus if needed
[[ ! -e /bin/pgstatus ]] && \
 cp /opt/plexguide/scripts/docker-no/superstatus/pgstatus /bin/pgstatus

#clear warning messages
for txtfile in certchecker nopassword pingchecker; do
  echo -n '' > /var/plexguide/$txtfile; done

# security scan
bash /opt/plexguide/scripts/startup/pg-auth-scan.sh &
# traefik cert validation
bash /opt/plexguide/scripts/startup/certchecker.sh &

sudo rm -r /opt/plexguide/menus/version/main.sh && sudo mkdir -p /opt/plexguide/menus/version/ && sudo wget --force-directories -O /opt/plexguide/menus/version/main.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Version-5/menus/version/main.sh 1>/dev/null 2>&1

# copying rclone config to user incase bonehead is not root
cp /root/.config/rclone/rclone.conf ~/.config/rclone/rclone.conf 1>/dev/null 2>&1

# Checking to see if VNC Container is Running
#file="/var/plexguide/vnc.yes"
#if [ -e "$file" ]
#then
#whiptail --title "Warning" --msgbox "You still have the VNC Container Running! Make sure to Destroy the Container via the VNC Menu!" 9 66
#fi
file="/var/plexguide/ubversion"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   bash /opt/plexguide/scripts/ubcheck/main.sh
fi

file="/var/plexguide/ask.yes"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   bash /opt/plexguide/menus/version/main.sh
   clear
      echo "1. Please STAR PG via http://github.plexguide.com"
      echo "2. Join the PG Discord via http://discord.plexguide.com"
      echo "3. Donate to PG via http://donate.plexguide.com"
      echo ""
      echo "TIP : Press Z, then [ENTER] in the Menus to Exit"
      echo "TIP : Menu Letters Displayed are HotKeys"
      echo "TIP : Update Plexguide Anytime, type: sudo pgupdate"
      echo "NOTE: Restart the Program Anytime, type: sudo plexguide"
      echo ""
   exit 0
fi

file="/var/plexguide/notification.yes"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   bash /opt/plexguide/menus/notifications/main.sh
fi

current=$( cat /var/plexguide/pg.preinstall ) 1>/dev/null 2>&1
stored=$( cat /var/plexguide/pg.preinstall.stored ) 1>/dev/null 2>&1
if [ "$current" == "$stored" ]
then
   touch /var/plexguide/message.no
else
   bash /opt/plexguide/scripts/baseinstall/main.sh
fi

## docker / ansible failure
file="/var/plexguide/startup.error" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
    dialog --title "Docker Failure" --msgbox "\nYour Docker is not installed or has failed\n\n- Most problems are due to using a VPS\n- Using an OutDated Kernel\n- 99% is your VPS provider being SPECIAL\n- A modified version of Ubuntu\n\nTry a Reboot First and RERUN. If it fails, please check with site forums." 0 0
    dialog --infobox "Exiting!" 0 0
    sleep 5
      clear
      echo "EXITED DUE TO DOCKER FAILURE!!!!!"
      echo ""
      echo "1. Please STAR PG via http://github.plexguide.com"
      echo "2. Join the PG Discord via http://discord.plexguide.com"
      echo "3. Donate to PG via http://donate.plexguide.com"
      echo ""
      echo "TIP : Press Z, then [ENTER] in the Menus to Exit"
      echo "TIP : Menu Letters Displayed are HotKeys"
      echo "TIP : Update Plexguide Anytime, type: sudo pgupdate"
      echo "NOTE: Restart the Program Anytime, type: sudo plexguide"
      echo ""
    exit
  fi

# checking to see if PG Edition was set
file="/var/plexguide/pg.edition"
if [ -e "$file" ]
then
   bash /opt/plexguide/menus/startup/message2.sh
fi

## Selects an edition
edition=$( cat /var/plexguide/pg.edition )

#### G-Drive Edition
if [ "$edition" == "PG Edition: GDrive" ]
  then
    bash /opt/plexguide/menus/main.sh
    exit
fi

#### Multiple Drive Edition
if [ "$edition" == "PG Edition: HD Multi" ]
  then
    bash /opt/plexguide/menus/localmain.sh
    exit
fi

#### Solo Drive Edition
if [ "$edition" == "PG Edition: HD Solo" ]
  then
    bash /opt/plexguide/menus/localmain.sh
    exit
fi

#### falls to this menu incase none work above
bash /opt/plexguide/scripts/baseinstall/edition.sh
