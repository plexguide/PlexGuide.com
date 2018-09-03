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

while [ "$menu" != "break" ]; do
  ################################################################## CORE
  echo "on" > /var/plexguide/warning.pgblitz
  downloadpath=$(cat /var/plexguide/server.hd.path)
  echo 'INFO - @Unencrypted PG Blitz Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  RCLONE_CONF="/root/.config/rclone/rclone.conf"

  #### RECALL VARIABLES START
  tdrive=$(grep "tdrive" $RCLONE_CONF 1>/dev/null 2>&1)
  gdrive=$(grep "gdrive" $RCLONE_CONF 1>/dev/null 2>&1)
  tcrypt=$(grep "tcrypt" $RCLONE_CONF 1>/dev/null 2>&1)
  gcrypt=$(grep "gcrypt" $RCLONE_CONF 1>/dev/null 2>&1)
  #### RECALL VARIABLES END

  ##### Unencrypted Portion ### Start
  if [ "$gdrive" == "[gdrive] " ] && [ "$tdrive" == "[tdrive] " ]; then
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
  if [ "$tcrypt" == "[tcrypt]" ] && [ "$gcrypt" == "[gcrypt] " ] && [ "$unencrypted" == "on" ]; then
      encryption="on"
      echo "Encrypted" > /var/plexguide/pgblitz.menustat
    else
      encryption="off"
  fi #
  #### Encrypted Portion ### END

################################################################## CORE
menu=$(cat /var/plexguide/manual.menu)
ansible-playbook /opt/plexguide/roles/menu-pgblitz/manual.yml
menu=$(cat /var/plexguide/manual.menu)

if [ "$menu" == "rclone" ]; then
  echo 'INFO - Selected: Transport Blitz Auto' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  rclone config
  touch /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
  mkdir -p /root/.config/rclone/
  chown -R 1000:1000 /root/.config/rclone/
  cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
fi

if [ "$menu" == "jsons" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz-valid
  warning=$(cat /var/plexguide/warning.pgblitz)
  if [ "$warning" == "on" ]; then
  echo ""
  echo "WARNING - Read Message Above in Regards to Failure!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
  exit
  fi

      echo 'INFO - DEPLOYING CLOUDBLITZ' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      #### Deploy CloudBlitz
      ansible-playbook /opt/plexguide/pg.yml --tags cloudblitz --extra-vars "skipend="yes --skip-tags cron
      #### Note How to Create Json files
      echo ""
      echo "Visit Port 7997 and Upload your JSON files | User: plex & Paswword: guide"
      echo "NOTE: Keys Store @ for Processing: /opt/appdata/pgblitz/keys/unprocessed/"
      echo ""
      read -n 1 -s -r -p "When Finished, Press [ANY KEY] to Continue!"
      echo ""
      echo ""
      echo "Please Wait! Destroying the BlitzCMD Container!"
      docker stop cloudblitz 1>/dev/null 2>&1
      docker rm cloudblitz 1>/dev/null 2>&1
      echo ""
      echo "WARNING: Make Sure to Use the E-Mail and Validation Processes!"
      read -n 1 -s -r -p "Press [ANY KEY] to Continue"
      echo ""
fi

if [ "$menu" == "email" ]; then
  echo 'INFO - Selected: Transport Blitz Manual' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz-valid
  warning=$(cat /var/plexguide/warning.pgblitz)
  if [ "$warning" == "on" ]; then
  echo ""
  echo "WARNING - Read Message Above in Regards to Failure!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
  exit
  fi

  echo 'INFO - DEPLOYED PG Blitz E-Mail Generator' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-pgblitz/scripts/emails.sh
  echo ""
  echo ""
  echo "WARNING: Make Sure to Use the E-Mail and Validation Processes!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  echo ""

fi

if [ "$menu" == "process" ]; then

  ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz-valid
  warning=$(cat /var/plexguide/warning.pgblitz)
  if [ "$warning" == "on" ]; then
  echo ""
  echo "WARNING - Read Message Above in Regards to Failure!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
  exit
  fi

  gdsa=`ls -la /opt/appdata/pgblitz/keys/unprocessed | awk '{print $9}' | grep GDSA | wc -l`;
  if [ $gdsa > 2 ]; then
    if [ "$encryption" == "on" ]; then
      dialog --title "SET ENCRYPTION PASSWORD" \
            --inputbox "Password: " 8 52 2>/opt/appdata/pgblitz/vars/password
      dialog --title "SET ENCRYPTION SALT" \
            --inputbox "Salt: " 8 52 2>/opt/appdata/pgblitz/vars/salt
    fi
    bash /opt/plexguide/roles/menu-pgblitz/scripts/validator.sh
  else
    dialog --title "WARNING!" --msgbox "\nIt seems like you have no JSON files :(" 0 0
  fi

fi

if [ "$menu" == "deploy" ]; then

  rm -r /opt/appdata/pgblitz/vars/automated 1>/dev/null 2>&1
  ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz-valid
  warning=$(cat /var/plexguide/warning.pgblitz)
  if [ "$warning" == "on" ]; then
  echo ""
  echo "WARNING - Read Message Above in Regards to Failure!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
  exit
  fi

  #### BLANK OUT PATH - This Builds For UnionFS
  rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
  touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

  ### Add GDSA Paths for UnionFS
  bash /opt/plexguide/roles/menu-pgblitz/scripts/ufbuilder.sh
  temp=$( cat /tmp/pg.gdsa.build )
  echo -n "$temp" >> /var/plexguide/unionfs.pgpath

  ### Remove All Prior Services
  ansible-playbook /opt/plexguide/roles/menu-pgblitz/service-remove.yml

  ### Execute Playbook Based on Version
  if [ "encrypted" != "on" ];then
    ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz --skip-tags encrypted
  else
    ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz
  fi

  ansible-playbook /opt/plexguide/pg.yml --tags blitzui
  echo ""
  read -n 1 -s -r -p "PGBlitz, PGDrives & BlitzUI Deployed! Press [ANY KEY] to continue"
  echo ""
fi

if [ "$menu" == "path" ]; then
  bash /opt/plexguide/scripts/baseinstall/harddrive.sh
fi

if [ "$menu" == "bad" ]; then

  ansible-playbook /opt/plexguide/pg.yml --tags menu-pgblitz-valid
  warning=$(cat /var/plexguide/warning.pgblitz)
  if [ "$warning" == "on" ]; then
  echo ""
  echo "WARNING - Read Message Above in Regards to Failure!"
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
  exit
  fi

  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  dialog --infobox "Reprocessing BAD JSONs (Please Wait)" 3 40
  sleep 2
  clear
  mv /opt/appdata/pgblitz/keys/badjson/* /opt/appdata/pgblitz/keys/unprocessed/ 1>/dev/null 2>&1
  bash /opt/plexguide/roles/menu-pgblitz/scripts/validator.sh
fi

if [ "$menu" == "baseline" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  dialog --infobox "Baselining PGBlitz (Please Wait)" 3 40
  sleep 2
  systemctl stop pgblitz 1>/dev/null 2>&1
  systemctl disable pgblitz 1>/dev/null 2>&1
  rm -r /root/.config/rclone/rclone.conf 1>/dev/null 2>&1
  rm -r /opt/appdata/pgblitz/keys/unprocessed/* 1>/dev/null 2>&1
  rm -r /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1
  rm -r /opt/appdata/pgblitz/keys/badjson/* 1>/dev/null 2>&1
  dialog --title "NOTE" --msgbox "\nKeys Cleared!\n\nYou must reconfigure RClone and Repeat the Process Again!" 0 0
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
