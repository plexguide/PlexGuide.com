#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
mkdir -p /opt/appdata/plexguide/emergency
mkdir -p /opt/appdata/plexguide
rm -rf /opt/appdata/plexguide/emergency/*
sleep 15
diskspace27=0

while true
do

# GDrive
if [[ $(rclone lsd --config /opt/appdata/pgblitz/rclone.conf gdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "🔴 Not Operational "> /var/plexguide/pg.gdrive; else echo "✅ Operational " > /var/plexguide/pg.gdrive; fi

if [[ $(ls -la /mnt/gdrive | grep "plexguide") == "" ]]; then
  echo "🔴 Not Operational"> /var/plexguide/pg.gmount; else echo "✅ Operational" > /var/plexguide/pg.gmount; fi

# TDrive
if [[ $(rclone lsd --config /opt/appdata/pgblitz/rclone.conf tdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "🔴 Not Operational"> /var/plexguide/pg.tdrive; else echo "✅ Operational" > /var/plexguide/pg.tdrive; fi

if [[ $(ls -la /mnt/tdrive | grep "plexguide") == "" ]]; then
  echo "🔴 Not Operational "> /var/plexguide/pg.tmount; else echo "✅ Operational" > /var/plexguide/pg.tmount; fi

# Union
if [[ $(rclone lsd --config /opt/appdata/pgblitz/rclone.conf pgunion: | grep "\<plexguide\>") == "" ]]; then
  echo "🔴 Not Operational "> /var/plexguide/pg.union; else echo "✅ Operational" > /var/plexguide/pg.union; fi

if [[ $(ls -la /mnt/unionfs | grep "plexguide") == "" ]]; then
  echo "🔴 Not Operational "> /var/plexguide/pg.umount; else echo "✅ Operational " > /var/plexguide/pg.umount; fi

# Disk Calculations - 4000000 = 4GB

leftover=$(df /opt/appdata/plexguide | tail -n +2 | awk '{print $4}')


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

##### Warning for Ports Open with Traefik Deployed
if [[ $(cat /var/plexguide/pg.ports) != "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "traefik" ]]; then
  echo "Warning: Traefik deployed with ports open! Server at risk for explotation!" > /opt/appdata/plexguide/emergency/message.a
elif [ -e "/opt/appdata/plexguide/emergency/message.a" ]; then rm -rf /opt/appdata/plexguide/emergency/message.a; fi

if [[ $(cat /var/plexguide/pg.ports) == "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "" ]]; then
  echo "Warning: Apps Cannot Be Accessed! Ports are Closed & Traefik is not enabled! Either deploy traefik or open your ports (which is worst for security)" > /opt/appdata/plexguide/emergency/message.b
elif [ -e "/opt/appdata/plexguide/emergency/message.b" ]; then rm -rf /opt/appdata/plexguide/emergency/message.b; fi
##### Warning for Bad Traefik Deployment - message.c is tied to traefik showing a status! Do not change unless you know what your doing
touch /opt/appdata/plexguide/traefik.check
domain=$(cat /var/plexguide/server.domain)
wget -q "https://portainer.${domain}" -O "/opt/appdata/plexguide/traefik.check"
if [[ $(cat /opt/appdata/plexguide/traefik.check) == "" && $(docker ps --format '{{.Names}}' | grep traefik) == "traefik" ]]; then
  echo "Traefik is Not Deployed Properly! Cannot Reach the Portainer SubDomain!" > /opt/appdata/plexguide/emergency/message.c
else
  if [ -e "/opt/appdata/plexguide/emergency/message.c" ]; then
  rm -rf /opt/appdata/plexguide/emergency/message.c; fi
fi
##### Warning for Traefik Rate Limit Exceeded
if [[ $(cat /opt/appdata/plexguide/traefik.check) == "" && $(docker logs traefik | grep "rateLimited") != "" ]]; then
  echo "$domain's rated limited exceed | Traefik (LetsEncrypt)! Takes upto one week to clear up (or use a new domain)" > /opt/appdata/plexguide/emergency/message.d
else
  if [ -e "/opt/appdata/plexguide/emergency/message.d" ]; then
  rm -rf /opt/appdata/plexguide/emergency/message.d; fi
fi

################# Generate Output
echo "" > /var/plexguide/emergency.log

if [[ $(ls /opt/appdata/plexguide/emergency) != "" ]]; then
countmessage=0
while read p; do
  let countmessage++
  echo -n "${countmessage}. " >> /var/plexguide/emergency.log
  echo "$(cat /opt/appdata/plexguide/emergency/$p)" >> /var/plexguide/emergency.log
done <<< "$(ls /opt/appdata/plexguide/emergency)"
else
  echo "NONE" > /var/plexguide/emergency.log
fi

sleep 5
done
