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
echo "on" > /var/plexguide/move.menu
menu=$(echo "on")
tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf | head -c8) 1>/dev/null 2>&1
gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf | head -c8) 1>/dev/null 2>&1
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
ansible-playbook /opt/plexguide/roles/menu-move/main.yml
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
  tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf | head -c8) 1>/dev/null 2>&1
  gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf | head -c8) 1>/dev/null 2>&1
fi

##### pgdrive # 4
if [ "$menu" == "pgdrive" ]; then

  #### BASIC CHECKS to STOP Deployment - START
  if [ "$gdrive" != "[gdrive]" ]; then
      echo 'FAILURE - Using MOVE: Must Configure gdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        dialog --title "WARNING!" --msgbox "\nYou are UTILZING PG Move!\n\nTo work, you MUST have a gdrive\nconfiguration in RClone!" 0 0
        bash /opt/plexguide/roles/menu-move/scripts/main.sh
        exit
  fi

  echo 'INFO - DEPLOYED PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  #### BLANK OUT PATH - This Builds For UnionFS
  rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
  touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

    echo -n "/mnt/gdrive=RO:" >> /var/plexguide/unionfs.pgpath
    #### IF EXIST - DEPLOY
    if [ "$tdrive" == "[tdrive]" ]; then
      #### ADDS TDRIVE to the UNIONFS PATH (Which is Optional)
      echo -n "/mnt/tdrive=RO:" >> /var/plexguide/unionfs.pgpath
    fi
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move

    #### REQUIRED TO DEPLOY ENDING
    echo ""
    read -n 1 -s -r -p "PG Drive & Move Deployed! Press [ANY KEY] to Continue"
fi

#### Bandwidth # 3
if [ "$menu" == "bw" ]; then

  #### BASIC CHECKS to STOP Deployment - START
  if [ "$gdrive" != "[gdrive]" ]; then
      echo 'FAILURE - Using MOVE: Must Configure gdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        dialog --title "WARNING!" --msgbox "\nYou are UTILZING PG Move!\n\nTo work, you MUST have a gdrive\nconfiguration in RClone!" 0 0
        bash /opt/plexguide/roles/menu-move/scripts/main.sh
        exit
  fi

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
