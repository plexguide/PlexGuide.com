#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
sleep 15

while true
do

# GDrive
if [[ $(rclone lsd --config /opt/appdata/plexguide/rclone.conf gdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "Not Operational ⚠️"> /var/plexguide/pg.gdrive; else echo "Operational ✅ " > /var/plexguide/pg.gdrive; fi

if [[ $(ls -la /mnt/gdrive | grep "plexguide") == "" ]]; then
  echo "Not Operational ⚠️"> /var/plexguide/pg.gmount; else echo "Operational ✅" > /var/plexguide/pg.gmount; fi

# TDrive
if [[ $(rclone lsd --config /opt/appdata/plexguide/rclone.conf tdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "Not Operational ⚠️"> /var/plexguide/pg.tdrive; else echo "Operational ✅" > /var/plexguide/pg.tdrive; fi

if [[ $(ls -la /mnt/tdrive | grep "plexguide") == "" ]]; then
  echo "Not Operational ⚠️"> /var/plexguide/pg.tmount; else echo "Operational ✅" > /var/plexguide/pg.tmount; fi

# Union
if [[ $(rclone lsd --config /opt/appdata/plexguide/rclone.conf pgunion: | grep "\<plexguide\>") == "" ]]; then
  echo "Not Operational ⚠️"> /var/plexguide/pg.union; else echo "Operational ✅" > /var/plexguide/pg.union; fi

if [[ $(ls -la /mnt/unionfs | grep "plexguide") == "" ]]; then
  echo "Not Operational ⚠️"> /var/plexguide/pg.umount; else echo "Operational ✅ " > /var/plexguide/pg.umount; fi

sleep 10
done
