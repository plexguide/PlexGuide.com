#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Checking Prior Server IDs"
echo "---------------------------------------------------"
echo ""
echo "Please StandBy:"

printid=$(rclone lsd gdrive:/plexguide/backup.old | awk '{ print $5 }')
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Prior PlexGuide Server IDs"
echo "---------------------------------------------------"
echo ""
echo $printid > /tmp/print.id
echo "Welcome to the PG Recovery ID System!"
echo
cat /tmp/print.id
echo ""
echo "To QUIT, type >>> exit"
break=no
while [ "$break" == "no" ]; do
read -p 'Type a Prior PlexGuide Recovery ID (Server): ' typed
storage=$(grep $typed /var/plexguide/ver.temp)

if [ "$typed" == "exit" ]; then
  echo ""
  echo "-------------------------------------------------"
  echo "SYSTEM MESSAGE: Exiting PG Recovery Interface"
  echo "--------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  touch /var/plexguide/exited.upgrade
  exit
fi

if [ "$storage" != "" ]; then
break=yes
echo $storage > /var/plexguide/recovery.id
#ansible-playbook /opt/plexguide/menu/interface/version/choice.yml
  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Recovery ID Set - $storage"
  echo "---------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  exit
else
  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: ID $storage does not exist!"
  echo "---------------------------------------------------"
  echo ""
  echo "NOTE: Try Again!"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  echo ""
  cat /tmp/print.id
  echo ""
fi

done
