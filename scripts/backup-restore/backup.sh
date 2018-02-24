#!/bin/bash

d=$(date +%Y-%m-%d-%T)

touch /opt/appdata/plexguide/backup

mfolder="/mnt/gdrive/plexguide/backup.old/backup-"
mpath="$mfolder$d"

mkdir /mnt/gdrive/plexguide/backup.old/ 1>/dev/null 2>&1
mkdir $mpath
mv /mnt/gdrive/plexguide/backup/* $mpath 

docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running

while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
done </opt/appdata/plexguide/running

rm -r /mnt/gdrive/plexguide/backup/watchtower.tar 1>/dev/null 2>&1
rm -r /opt/appdata/plexguide/backup 1>/dev/null 2>&

read -n 1 -s -r -p "Press any key to continue "