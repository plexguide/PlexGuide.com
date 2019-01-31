#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
echo "on" > /var/plexguide/multi.menu
menu=$(echo "on")

#### Installs Default Variables If Missing
mkdir -p /opt/appdata/plexguide/multi/
file="/var/plexguide/multi.read"
  if [ -e "$file" ]
    then
    echo "" 1>/dev/null 2>&1
    else
    touch /var/plexguide/multi.read
  fi
file="/var/plexguide/multi.unionfs"
  if [ -e "$file" ]
    then
    echo "" 1>/dev/null 2>&1
    else
    touch /var/plexguide/multi.unionfs
  fi
file="/var/plexguide/multi.build"
  if [ -e "$file" ]
    then
    echo "" 1>/dev/null 2>&1
    else
    touch /var/plexguide/multi.build
  fi

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/multi.menu)
ansible-playbook /opt/plexguide/menu/multihd/main.yml
menu=$(cat /var/plexguide/multi.menu)

if [ "$menu" == "addpath" ]; then
  echo 'INFO - Selected: Add Mounts to List Interface' > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
  number=1
  break=0
    until [ "$break" == "1" ]; do
      check=$(grep -w "$number" /var/plexguide/multi.list)
      if [ "$check" == "$number" ]; then
          break=0
          let "number++"
          echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
        else
          break=1
      fi
    done
  echo $number > /var/plexguide/multi.filler
  ansible-playbook /opt/plexguide/menu/multihd/pre.yml
  bash /opt/plexguide/menu/multihd/scripts/ufbuilder.sh
fi

if [ "$menu" == "removepath" ]; then
  echo 'INFO - Selected: Remove Path Option for Multi-HD' > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
  number=1
  break=0
    until [ "$break" == "1" ]; do
      check=$(grep -w "$number" /var/plexguide/multi.list)
      if [ "$check" == "$number" ]; then
          break=0
          let "number++"
          echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
        else
          break=1
      fi
    done
  echo $number > /var/plexguide/multi.filler
  ansible-playbook /opt/plexguide/menu/multihd/remove.yml
  bash /opt/plexguide/menu/multihd/scripts/ufbuilder.sh

fi

if [ "$menu" == "unionfs" ]; then
  echo 'INFO - Selected: Deploy UnionFS' > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
  ansible-playbook /opt/plexguide/menu/multihd/service-remove.yml
  ansible-playbook /opt/plexguide/menu/multihd/mergerfs.yml
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
