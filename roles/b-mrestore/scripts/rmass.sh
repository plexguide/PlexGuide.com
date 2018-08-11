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
echo 'INFO - @Restore Mass Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
serverid=$( cat /var/plexguide/server.id )

d=$(date +%Y-%m-%d-%T) 1>/dev/null 2>&1

touch /opt/appdata/plexguide/restore 1>/dev/null 2>&1
sudo rm -r /opt/appdata/plex/trans* 1>/dev/null 2>&1

mfolder="/mnt/gdrive/plexguide/restore/$serverid/restore-$d"

mkdir -p $mfolder 1>/dev/null 2>&1
mv /mnt/gdrive/plexguide/restore/$serverid/* $mfolder 1>/dev/null 2>&1

##################################################### Builds Restore List - START
#### Recall Download Point
mnt=/mnt
server=server01

mnt=$(cat /var/plexguide/server.hd.path)
mkdir -p $mnt/pgops

#### Recalls List for Restore Operations
ls -la /mnt/gdrive/plexguide/backup/$serverid | awk '{ print $9 }' | tail -n +2 > $mnt/pgops/restore.list

#### Combine for Simplicity
path=$(echo $mnt/pgops/restore.list)

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
##################################################### Builds Restore List - END

clear
#### Loops Through Built Up List
while read p; do
  p=${p::-4}
  echo $p > /tmp/program_var
  running=$(docker ps -a --format "{{.Names}}" | grep -oP $p)
  if [ "$p" == "$running" ];then
  touch $mnt/pgops/$p.running 1>/dev/null 2>&1
  fi
  ansible-playbook /opt/plexguide/pg.yml --tags b-mrestore
  rm -r $mnt/pgops/$p.running 1>/dev/null 2>&1
  echo ""
  echo "$p - restored"
  sleep 3
done <$path

read -n 1 -s -r -p "Mass Restore Process Complete - Press [ANY KEY] to CONTINUE"

rm -r /opt/appdata/plexguide/restore 1>/dev/null 2>&1
dialog --title "PG Restore Status" --msgbox "\nMass Application Restore Complete!" 0 0
clear

exit 0
