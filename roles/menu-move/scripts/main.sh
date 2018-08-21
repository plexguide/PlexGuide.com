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

#### Recalls from prior menu what user selected
selected=Move
################################################################## CORE

file="/var/plexguide/move.bw"
if [ -e "$file" ]
  then
    echo "" 1>/dev/null 2>&1
  else
    echo "10" > /var/plexguide/move.bw
fi


while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/move.menu)
ansible-playbook /opt/plexguide/basics.yml --tags menu-move
menu=$(cat /var/plexguide/move.menu)

if [ "$menu" == "rclone" ]; then
  echo 'INFO - Selected: Transport Blitz Auto' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/pgblitz/scripts/automated.sh

fi

if [ "$menu" == "pgdrive" ]; then

  echo 'INFO - Configured RCLONE for PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

              #### RClone Missing Warning - END
              rclone config
              touch /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
              #### GREP Checks
              tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
              gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
              mkdir -p /root/.config/rclone/
              chown -R 1000:1000 /root/.config/rclone/
              cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
              #################### installing dummy file for prep of pgdrive deployment
              file="/mnt/unionfs/plexguide/pgchecker.bin"
              if [ -e "$file" ]; then
                 echo 'PASSED - UnionFS is Properly Working - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
              else
                 mkdir -p /mnt/tdrive/plexguide/ 1>/dev/null 2>&1
                 mkdir -p /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
                 mkdir -p /tmp/pgchecker/ 1>/dev/null 2>&1
                 touch /tmp/pgchecker/pgchecker.bin 1>/dev/null 2>&1
                 rclone copy /tmp/pgchecker gdrive:/plexguide/ &>/dev/null &
                 rclone copy /tmp/pgchecker tdrive:/plexguide/ &>/dev/null &
                 echo 'INFO - Deployed PGChecker.bin - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
              fi
fi

if [ "$menu" == "move" ]; then
  echo 'INFO - DEPLOYED PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

              #### RECALL VARIABLES START
              tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
              gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
              #### RECALL VARIABLES END

              #### REQUIRED TO DEPLOY STARTING
              ansible-playbook /opt/plexguide/pg.yml --tags pgdrive_standard

              #### BLANK OUT PATH - This Builds For UnionFS
              rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
              touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

              #### IF EXIST - DEPLOY
              if [ "$tdrive" == "[tdrive]" ]
                then

                #### ADDS TDRIVE to the UNIONFS PATH
                echo -n "/mnt/tdrive=RO:" >> /var/plexguide/unionfs.pgpath
                ansible-playbook /opt/plexguide/pg.yml --tags tdrive
              fi

              if [ "$gdrive" == "[gdrive]" ]
                then

                #### ADDS GDRIVE to the UNIONFS PATH
                echo -n "/mnt/gdrive=RO:" >> /var/plexguide/unionfs.pgpath
                ansible-playbook /opt/plexguide/pg.yml --tags gdrive
              fi

              #### REQUIRED TO DEPLOY ENDING
              ansible-playbook /opt/plexguide/pg.yml --tags unionfs
              ansible-playbook /opt/plexguide/pg.yml --tags ufsmonitor

              read -n 1 -s -r -p "Press any key to continue"
              dialog --title "NOTE" --msgbox "\nPG Drive Deployed!!" 0 0
fi

if [ "$menu" == "st2" ]; then

  dialog --title "Change the BW Limit" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Type a Number 1 - 999 [Example: 50 = 50MB ]" 8 50 2>/var/plexguide/move.number
  number=$(cat /var/plexguide/move.number)

if [ $number -gt 999 -o $number -lt 1 ]
then
  dialog --title "NOTE!" --msgbox "\nYou Failed to Type a Number Between 1 - 999\n\nExit! Nothing Changed!" 0 0
  exit
fi
  echo $number > /var/plexguide/move.bw
  dialog --title "NOTE!" --msgbox "\nYou Must Redeploy [PG Move] for the BWLimit Change!" 0 0
fi

F)
ansible-playbook /opt/plexguide/scripts/test/check-remove/tasks/main.yml
echo 'INFO - REMOVED OLD SERVICES' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
#ansible-role services_remove
dialog --title " All Google Related Services Removed!" --msgbox "\nPlease re-run:-\n             'Deploy : PGDrive'\n     and     'Deploy : $selected'" 0 0

fi

if [ "$menu" == "plexdrive" ]; then
  echo 'INFO - Selected: Backup & Restore' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "plexdrive" > /var/plexguide/menu.select
  bash /opt/plexguide/roles/plexdrive/scripts/rc-pd.sh

fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
