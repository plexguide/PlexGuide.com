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
echo 'INFO - @Backup Mass Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
server=$( cat /var/plexguide/server.id )

d=$(date +%Y-%m-%d-%T) 1>/dev/null 2>&1

touch /opt/appdata/plexguide/backup 1>/dev/null 2>&1
sudo rm -r /opt/appdata/plex/trans* 1>/dev/null 2>&1

mfolder="/mnt/gdrive/plexguide/backup.old/$server/backup-$d"

mkdir -p $mfolder 1>/dev/null 2>&1
mv /mnt/gdrive/plexguide/backup/$server/* $mfolder 1>/dev/null 2>&1

##################################################### Builds Backup List - START
#### Recall Download Point
mnt=$(cat /var/plexguide/server.hd.path)
mkdir -p $mnt/pgops

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

clear
#### Loops Through Built Up List
while read p; do
  echo $p > /tmp/program_var
  running=$(docker ps -a --format "{{.Names}}" | grep -oP $p)
  if [ "$p" == "$running" ];then
  touch $mnt/pgops/$p.running 1>/dev/null 2>&1
  fi
  ansible-playbook /opt/plexguide/pg.yml --tags backup
  rm -r $mnt/pgops/$p.running 1>/dev/null 2>&1
  echo ""
  echo "$p Backed Up"
  sleep 4
done <$path

read -n 1 -s -r -p "Mass Backup Process Complete - Press [ANY KEY] to CONTINUE"

rm -r /opt/appdata/plexguide/backup 1>/dev/null 2>&1
dialog --title "PG Backup Status" --msgbox "\nMass Application Backup Complete!" 0 0
clear

exit 0
