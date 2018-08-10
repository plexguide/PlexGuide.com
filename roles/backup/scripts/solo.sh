#!/bin/bash
#
# [PlexGuide Menu]
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
clear
rm -r /tmp/backup.build 1>/dev/null 2>&1
touch /tmp/backup.build 1>/dev/null 2>&1

#### Recall Download Point
mnt=$(cat /var/plexguide/server.hd.path)

#### Recalls List for Backup Operations
ls -la /opt/appdata | awk '{ print $9}' | tail -n +4 > $mnt/pgops/backup.list

#### Combine for Simplicity
path=$(echo $mnt/pgops/backup.list)

#### Remove Items from List
sed -i -e "/traefik/d" $path
sed -i -e "/watchtower/d" $path
sed -i -e "/word*/d" $path
sed -i -e "/x2go*/d" $path
sed -i -e "/speed*/d" $path
sed -i -e "/netdata/d" $path
sed -i -e "/pgtrak/d" $path
sed -i -e "/plexguide/d" $path
sed -i -e "/pgdupes/d" $path
sed -i -e "/portainer/d" $path
sed -i -e "/cloudplow/d" $path
sed -i -e "/phlex/d" $path
sed -i -e "/pgblitz/d" $path
sed -i -e "/cloudblitz/d" $path
##################################################### Builds Backup List - END

#echo $p > /tmp/program_var
#running=$(docker ps -a --format "{{.Names}}" | grep -oP $p)
#if [ "$p" == "$running" ];then
#touch $mnt/pgops/$p.running 1>/dev/null 2>&1
#fi

#### Commenting Out To Let User See
while read p; do
  echo -n $p >> /tmp/backup.build
  echo -n " " >> /tmp/backup.build
done </tmp/backup.list
ansible-playbook /opt/plexguide/pg.yml --tags backup --extra-vars "switch=on"
echo ""
read -n 1 -s -r -p "Program Backed Up - Press [Any Key] to Continue" ;;
