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

#### Install MergerFS If Missing
file="/usr/bin/mergerfs"
  if [ -e "$file" ]
    then
echo 'INFO - MergerFS is Already Installed' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    else
echo 'INFO - Installing MERGER FS' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
echo ""
echo "---------------------------------------------------"
echo "PLEASE STANDBY"
echo "System Message: Installing MergerFS for PG Multi HD"
echo "---------------------------------------------------"
echo ""
sleep 3
wget "https://github.com/trapexit/mergerfs/releases/download/2.24.2/mergerfs_2.24.2.ubuntu-xenial_amd64.deb" #1>/dev/null 2>&1
apt-get install g++ pkg-config git git-buildpackage pandoc debhelper libfuse-dev libattr1-dev -y
git clone https://github.com/trapexit/mergerfs.git 1>/dev/null 2>&1
cd mergerfs
make clean #1>/dev/null 2>&1
make deb #1>/dev/null 2>&1
cd ..
dpkg -i mergerfs*_amd64.deb #1>/dev/null 2>&1
rm mergerfs*_amd64.deb mergerfs*_amd64.changes mergerfs*.dsc mergerfs*.tar.gz #1>/dev/null 2>&1
  fi
####

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/multi.menu)
ansible-playbook /opt/plexguide/roles/menu-multi/main.yml
menu=$(cat /var/plexguide/multi.menu)

if [ "$menu" == "addpath" ]; then
  echo 'INFO - Selected: Add Mounts to List Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  number=1
  break=0
    until [ "$break" == "1" ]; do
      check=$(grep -w "$number" /var/plexguide/multi.list)
      if [ "$check" == "$number" ]; then
          break=0
          let "number++"
          echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        else
          break=1
      fi
    done
  echo $number > /var/plexguide/multi.filler
  ansible-playbook /opt/plexguide/roles/menu-multi/pre.yml
  bash /opt/plexguide/roles/menu-multi/scripts/ufbuilder.sh
fi

if [ "$menu" == "removepath" ]; then
  echo 'INFO - Selected: Remove Path Option for Multi-HD' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  number=1
  break=0
    until [ "$break" == "1" ]; do
      check=$(grep -w "$number" /var/plexguide/multi.list)
      if [ "$check" == "$number" ]; then
          break=0
          let "number++"
          echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        else
          break=1
      fi
    done
  echo $number > /var/plexguide/multi.filler
  ansible-playbook /opt/plexguide/roles/menu-multi/remove.yml
  bash /opt/plexguide/roles/menu-multi/scripts/ufbuilder.sh

fi

if [ "$menu" == "unionfs" ]; then
  echo 'INFO - Selected: Deploy UnionFS' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/roles/menu-multi/service-remove.yml
  ansible-playbook /opt/plexguide/roles/menu-multi/mergerfs.yml
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
