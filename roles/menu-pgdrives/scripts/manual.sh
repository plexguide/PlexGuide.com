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
echo "on" > /var/plexguide/manual.menu
menu=$(echo "on")
rm -f /opt/appdata/pgblitz/vars/automated

while [ "$menu" != "break" ]; do
  ################################################################## CORE
  echo "on" > /var/plexguide/warning.pgblitz
  echo 'INFO - @Unencrypted PG Blitz Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  #### RECALL VARIABLES START
  tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
  gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
  tcrypt=$(grep "tcrypt" /root/.config/rclone/rclone.conf)
  gcrypt=$(grep "gcrypt" /root/.config/rclone/rclone.conf)
  #### RECALL VARIABLES END

  ##### Unencrypted Portion ### Start
  if [ "$gdrive" == "[gdrive]" ] && [ "$tdrive" == "[tdrive]" ]; then
      unencrypted="on"
      echo "UnEncrypted" > /var/plexguide/pgblitz.menustat
    else
      unencrypted="off"
      echo "Not Configured" > /var/plexguide/pgblitz.menustat
  fi
  if [ "$encryption" == "on" ]; then
    echo "Encrypted" > /var/plexguide/pgblitz.menustat
  fi
  ##### UnEncrypted Portion ### END

  ##### Encryption Portion ### Start
  if [ "$tcrypt" == "[tcrypt]" ] && [ "$gcrypt" == "[gcrypt]" ] && [ "$unencrypted" == "on" ]; then
      encryption="on"
      echo "Encrypted" > /var/plexguide/pgblitz.menustat
    else
      encryption="off"
  fi #
  #### Encrypted Portion ### END

################################################################## CORE
menu=$(cat /var/plexguide/manual.menu)
ansible-playbook /opt/plexguide/roles/menu-pgdrives/manual.yml
menu=$(cat /var/plexguide/manual.menu)

if [ "$menu" == "rclone" ]; then
  echo 'INFO - Selected: Transport Blitz Auto' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  rclone config
  touch /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
  mkdir -p /root/.config/rclone/
  chown -R 1000:1000 /root/.config/rclone/
  cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
fi

if [ "$menu" == "keys" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  if [ $unencrypted == "off" ]; then
  echo ""
  echo "WARNING - GDrive and/or TDrive is Not Configured!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgdrives/scripts/manual.sh
  exit
  fi

  echo gcloud > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

fi

  ################### OLD
  if [ "$menu" == "process" ]; then
    if [ $unencrypted == "off" ]; then
    echo ""
    echo "WARNING - GDrive and/or TDrive is Not Configured!"
    read -n 1 -s -r -p "Press [ANY KEY] to Continue"
    bash /opt/plexguide/roles/menu-pgdrives/scripts/manual.sh
    exit
    fi

  ### prior interger expected incase debugging required
    gdsa=$(ls -la /opt/appdata/pgblitz/keys/unprocessed | awk '{print $9}' | tail -n +4 | wc -l)
    if [ "$gdsa" -ne "0" ]; then
      if [ "$encryption" == "on" ]; then
        dialog --title "SET ENCRYPTION PASSWORD" \
              --inputbox "Password: " 8 52 2>/opt/appdata/pgblitz/vars/password
        dialog --title "SET ENCRYPTION SALT" \
              --inputbox "Salt: " 8 52 2>/opt/appdata/pgblitz/vars/salt
      fi
      bash /opt/plexguide/roles/menu-pgdrives/scripts/validator.sh
    else
      echo ""
      echo "WARNING! No JSON files are detected for processing!"
      read -n 1 -s -r -p "Press [ANY KEY] to Continue"
      echo ""
    fi
  ################### OLD
fi

if [ "$menu" == "deploy" ]; then

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
    echo "gdrive is mandatory for rclone! It's what controls your backups/restores"
    echo "Make your corrections and redeploy again!"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue"
    bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
    exit
  fi
  echo ""

  #### BLANK OUT PATH - This Builds For UnionFS
  rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
  touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

  ### Add GDSA Paths for UnionFS
  bash /opt/plexguide/roles/menu-pgdrives/scripts/ufbuilder.sh
  temp=$( cat /tmp/pg.gdsa.build )
  echo -n "$temp" >> /var/plexguide/unionfs.pgpath

  ### Remove All Prior Services
  ansible-playbook /opt/plexguide/roles/menu-pgdrives/service-remove.yml

  ### Execute Playbook Based on Version
  if [ "$encryption" != "on" ];then
    ansible-playbook /opt/plexguide/pg.yml --tags menu-pgdrives --skip-tags encrypted
  else
    ansible-playbook /opt/plexguide/pg.yml --tags menu-pgdrives
  fi

  echo ""
  echo "--------------------------------------------------------------------------"
  echo "PG Drives: Admin9705"
  echo "--------------------------------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "PGBlitz & PGDrives Deployed! Press [ANY KEY] to Continue"

  ### Variable to Noify System PGBlitz Deployed
  echo yes > /var/plexguide/project.deployed
fi

if [ "$menu" == "path" ]; then
  bash /opt/plexguide/scripts/baseinstall/harddrive.sh
fi

if [ "$menu" == "bad" ]; then

  if [ $unencrypted == "off" ]; then
  echo ""
  echo "WARNING - GDrive and/or TDrive is Not Configured!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgdrives/scripts/manual.sh
  exit
  fi

  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  dialog --infobox "Reprocessing BAD JSONs (Please Wait)" 3 40
  sleep 2
  clear
  mv /opt/appdata/pgblitz/keys/badjson/* /opt/appdata/pgblitz/keys/unprocessed/ 1>/dev/null 2>&1
  bash /opt/plexguide/roles/menu-pgdrives/scripts/validator.sh
fi

if [ "$menu" == "disable" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  sudo systemctl stop pgblitz 1>/dev/null 2>&1
  sudo systemctl rm pgblitz 1>/dev/null 2>&1
  dialog --title "NOTE" --msgbox "\nPG Blitz is Disabled!\n\nYou must rerun PGDrives & PGBlitz to Enable Again!" 0 0
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
