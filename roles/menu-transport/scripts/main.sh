#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
echo "on" > /var/plexguide/transport.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/transport.menu)
ansible-playbook /opt/plexguide/roles/menu-transport/main.yml
menu=$(cat /var/plexguide/transport.menu)

if [ "$menu" == "move" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menu/interface/move/scripts/main.sh
fi

if [ "$menu" == "blitzmanual" ]; then
  echo 'INFO - Selected: Transport Blitz Manual' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
fi

if [ "$menu" == "pgdrives" ]; then
  echo 'INFO - Selected: PGDrives' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-pgdrives/scripts/manual.sh
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
##### UnEncrypted Portion ### END

################################################################## CORE

file="/var/plexguide/move.bw"
if [ -e "$file" ]
  then
    echo "" 1>/dev/null 2>&1
  else
    echo "10" > /var/plexguide/move.bw
fi

#### exit # 1
while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/move.menu)
ansible-playbook /opt/plexguide/menu/interface/move/main.yml
menu=$(cat /var/plexguide/move.menu)

#### rclone # 2
if [ "$menu" == "rclone" ]; then
  echo 'INFO - Configured RCLONE for PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  #### RClone Missing Warning - END
  echo ""
  rclone config
  mkdir -p /root/.config/rclone/
  chown -R 1000:1000 /root/.config/rclone/
  cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
  echo ""
  bash /opt/plexguide/menu/interface/move/scripts/main.sh
  exit
fi

##### pgdrive # 4
if [ "$menu" == "pgdrive" ]; then

  #### BASIC CHECKS to STOP Deployment - START

  echo 'INFO - DEPLOYED PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ############################################# GDRIVE VALDIATION CHECKS - START
  echo ""
  echo "--------------------------------------------------------------------------"
  echo "System Message: Conducting RClone GDrive Validation Check"
  echo "--------------------------------------------------------------------------"
  sleep 2
  echo ""
  echo "--------------------------------------------------------------------------"
  echo "SYSTEM MESSAGE: Creating Test Directory - gdrive:/plexguide "
  echo "--------------------------------------------------------------------------"
  rclone mkdir gdrive:/plexguide
  sleep 2
  echo ""
  echo "--------------------------------------------------------------------------"
  echo "SYSTEM MESSAGE: Checking Existance of gdrive:/plexguide"
  echo "--------------------------------------------------------------------------"
  rcheck=$(rclone lsd gdrive: | grep -oP plexguide | head -n1)
  sleep 2
  if [ "$rcheck" != "plexguide" ];then
    echo ""
    echo "--------------------------------------------------------------------------"
    echo "SYSTEM MESSAGE: RClone GDrive Validation Check Failed"
    echo "--------------------------------------------------------------------------"
    echo ""
    echo "gdrive is mandatory! It's required for backup/restore operations!"
    echo "Make sure you configured gdrive correctly and redeploy again!"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue"
    bash /opt/plexguide/menu/interface/move/scripts/main.sh
    exit
  fi
  echo ""
  ############################################# GDRIVE VALDIATION CHECKS - END

    ansible-playbook /opt/plexguide/menu/interface/move/remove-service.yml

    if [ "$encryption" == "off" ]; then
      ansible-playbook /opt/plexguide/pg.yml --tags menu-move --skip-tags encrypted
    else
      ansible-playbook /opt/plexguide/pg.yml --tags menu-move
    fi
    #### REQUIRED TO DEPLOY ENDING - BELOW UPDATES THE VARIABLE ON THE FRONT PAGE
    tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf | head -n1 | cut -b1-8)
    gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf | head -n1 | cut -b1-8)
    tcrypt=$(grep "tcrypt" /root/.config/rclone/rclone.conf | head -n1 | cut -b1-8)
    gcrypt=$(grep "gcrypt" /root/.config/rclone/rclone.conf | head -n1 | cut -b1-8)
    echo ""

    ##### Unencrypted Portion ### Start
    if [ "$gdrive" == "[gdrive]" ] && [ "$gcrypt" == "[gcrypt]" ]; then
        unencrypted="off"
        encryption="on"
        echo "Encrypted" > /var/plexguide/pgblitz.menustat
      else
        unencrypted="on"
        encryption="off"
        echo "UnEncrypted" > /var/plexguide/pgblitz.menustat
    fi

    #### To Ensure Not Configured Message Comes Up
    if [ "$gdrive" != "[gdrive]" ] && [ "$gcrypt" != "[gcrypt]" ]; then
      echo "Not Configured" > /var/plexguide/pgblitz.menustat
    fi
    if [ "$gdrive" != "[gdrive]" ] && [ "$gcrypt" == "[gcrypt]" ]; then
      echo "Not Configured" > /var/plexguide/pgblitz.menustat
    fi
    ##### UnEncrypted Portion ### END
    read -n 1 -s -r -p "PG Drive & Move Deployed! Press [ANY KEY] to Continue"
fi

#### Bandwidth # 3
if [ "$menu" == "bw" ]; then

  #### BASIC CHECKS to STOP Deployment - START

  dialog --title "Change the BW Limit" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Type a Number 1 - 999 [Example: 50 = 50MB ]" 8 50 2>/var/plexguide/move.number
  number=$(cat /var/plexguide/move.number)

  if [ $number -gt 999 -o $number -lt 1 ]; then
    dialog --title "NOTE!" --msgbox "\nYou Failed to Type a Number Between 1 - 999\n\nExit! Nothing Changed!" 0 0
    exit
  else
    echo $number > /var/plexguide/move.bw
    echo ""
    read -n 1 -s -r -p "You Must Redeploy [PG Move] for the BWLimit Change! Press [ANY KEY] to Continue"
  fi

fi

echo 'INFO - Looping: PG Move System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: PG Move System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
