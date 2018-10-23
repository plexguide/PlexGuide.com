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
menu=$(cat /var/plexguide/final.choice)

file="/var/plexguide/watchtower.id"
  if [ ! -e "$file" ]; then
    echo NOT-SET > /var/plexguide/watchtower.id
  fi

  echo ""
  echo "-----------------------------------------------------"
  echo "SYSTEM MESSAGE: Please Read the Following Information"
  echo "-----------------------------------------------------"
  echo ""
  echo "NOTE: WatchTower Auto-Updates Your Containers! Soon"
  echo "as a containers is released, it updates!"
  echo ""
  echo "WARNING: Auto-Updates can be problematic if the"
  echo "released containers is bugged! Rare, but happens!"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue"
  echo ""

  ### part 2
  typed=nullstart
  prange="1 2 3 4"
  tcheck=""
  break=off
  while [ "$break" == "off" ]; do
    echo "--------------------------------------------------------"
    echo "SYSTEM MESSAGE: Set WatchTower Preference"
    echo "--------------------------------------------------------"
    echo ""
    echo "1. EXIT WatchTower Interface"
    echo "2. Containers:  All Auto-Update"
    echo "3. Containers:  All Auto-Update | Except Plex & Emby"
    echo "4. Containers:  Never Update    | Conduct Manual Updates"
    echo ""
    read -p 'Type a Number from 1 - 4 | PRESS [ENTER]: ' typed
    tcheck=$(echo $prange | grep $typed)
    echo ""

if [ "$typed" != "1" ]; then

      if [ "$tcheck" == "" ]; then
        echo "--------------------------------------------------------"
        echo "SYSTEM MESSAGE: Failed! Type a Number from 1 - 4"
        echo "--------------------------------------------------------"
        echo ""
        read -n 1 -s -r -p "Press [ANY KEY] to Continue "
        echo ""
        echo ""
      else
        echo "----------------------------------------------"
        echo "SYSTEM MESSAGE: Passed! WatchTower Pref Set!"
        echo "----------------------------------------------"
        echo ""
        echo $typed > /var/plexguide/watchtower.id
        read -n 1 -s -r -p "Press [ANY KEY] to Continue "
        break=on
      fi
else
  echo "--------------------------------------------------------"
  echo "SYSTEM MESSAGE: Exiting - WatchTower Interface!"
  echo "--------------------------------------------------------"
  echo ""
  break=on
#### Final fi
fi
done

if [ "$typed" == "2" ]; then
cat /opt/plexguide/menu/interface/apps/app.list > /tmp/watchtower.set
ansible-playbook /opt/plexguide/programs/containers/watchtower.yml
fi

### need to exempt plex and emby
if [ "$typed" == "3" ]; then
cat /opt/plexguide/menu/interface/apps/app.list > /tmp/watchtower.set
sed -i -e "/plex/d" /tmp/watchtower.set 1>/dev/null 2>&1
sed -i -e "/emby/d" /tmp/watchtower.set 1>/dev/null 2>&1
ansible-playbook /opt/plexguide/programs/containers/watchtower.yml
fi

### need to exempt plex and emby
if [ "$typed" == "4" ]; then
echo null > /tmp/watchtower.set
ansible-playbook /opt/plexguide/programs/containers/watchtower.yml
fi

idtest=$(cat /var/plexguide/watchtower.id)
if [ "$idtest" == "NOT-SET" ]; then
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Never Set a WatchTower Preference!"
  echo "---------------------------------------------------"
  echo ""
  echo "NOTE: You Must at Least Set WatchTower One Time!"
  echo "Restarting Process"
  echo
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  bash /opt/plexguide/menu/interface/watchtower/file.sh
  echo ""
  exit
fi
