#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
mkdir -p /opt/appdata/plexguide/emergency
sleep 15
diskspace27=0

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

# Disk Calculations - 4000000 = 4GB

leftover=$(cat df /opt/appdata/plexguide | tail -n +2 | awk '{print $4}')
  #used=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $3}')
  #capacity=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $2}')
  #percentage=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $5}')

if [[ "$leftover" -lt "3000000" ]]; then
  diskspace27=1
  echo "Emergency: Primary DiskSpace Under 3GB - Stopped Media Programs & Downloading Programs (i.e. Plex, NZBGET, RuTorrent)" > /opt/appdata/plexguide/emergency/message.1
  docker stop plex 1>/dev/null 2>&1
  docker stop emby 1>/dev/null 2>&1
  docker stop jellyfin 1>/dev/null 2>&1
  docker stop nzbget 1>/dev/null 2>&1
  docker stop sabnzbd 1>/dev/null 2>&1
  docker stop rutorrent 1>/dev/null 2>&1
  docker stop deluge 1>/dev/null 2>&1
  docker stop qbitorrent 1>/dev/null 2>&1
elif [[ "$leftover" -gt "3000000" && "$diskspace27" == "1" ]]; then
  docker start plex 1>/dev/null 2>&1
  docker start emby 1>/dev/null 2>&1
  docker start jellyfin 1>/dev/null 2>&1
  docker start nzbget 1>/dev/null 2>&1
  docker start sabnzbd 1>/dev/null 2>&1
  docker start rutorrent 1>/dev/null 2>&1
  docker start deluge 1>/dev/null 2>&1
  docker start qbitorrent 1>/dev/null 2>&1
  rm -rf /opt/appdata/plexguide/emergency/message.1
  diskspace27=0
fi

sleep 5
done
