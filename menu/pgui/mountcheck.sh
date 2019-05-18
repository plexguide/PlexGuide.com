#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
mkdir -p /pg/data/blitz/emergency
mkdir -p /pg/data/blitz
rm -rf /pg/data/blitz/emergency/*
sleep 15
diskspace27=0

while true
do

# GDrive
if [[ $(rclone lsd --config /pg/data/blitz/rclone.conf gdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "🔴 Not Operational "> /pg/var/pg.gdrive; else echo "✅ Operational " > /pg/var/pg.gdrive; fi

if [[ $(ls -la /mnt/gdrive | grep "plexguide") == "" ]]; then
  echo "🔴 Not Operational"> /pg/var/pg.gmount; else echo "✅ Operational" > /pg/var/pg.gmount; fi

# TDrive
if [[ $(rclone lsd --config /pg/data/blitz/rclone.conf tdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "🔴 Not Operational"> /pg/var/pg.tdrive; else echo "✅ Operational" > /pg/var/pg.tdrive; fi

if [[ $(ls -la /mnt/tdrive | grep "plexguide") == "" ]]; then
  echo "🔴 Not Operational "> /pg/var/pg.tmount; else echo "✅ Operational" > /pg/var/pg.tmount; fi

# Union
if [[ $(rclone lsd --config /pg/data/blitz/rclone.conf pgunion: | grep "\<plexguide\>") == "" ]]; then
  echo "🔴 Not Operational "> /pg/var/pg.union; else echo "✅ Operational" > /pg/var/pg.union; fi

if [[ $(ls -la /mnt/unionfs | grep "plexguide") == "" ]]; then
  echo "🔴 Not Operational "> /pg/var/pg.umount; else echo "✅ Operational " > /pg/var/pg.umount; fi

# Disk Calculations - 4000000 = 4GB

leftover=$(df /pg/data/blitz | tail -n +2 | awk '{print $4}')


if [[ "$leftover" -lt "3000000" ]]; then
  diskspace27=1
  echo "Emergency: Primary DiskSpace Under 3GB - Stopped Media Programs & Downloading Programs (i.e. Plex, NZBGET, RuTorrent)" > /pg/data/blitz/emergency/message.1
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
  rm -rf /pg/data/blitz/emergency/message.1
  diskspace27=0
fi

##### Warning for Ports Open with Traefik Deployed
if [[ $(cat /pg/var/pg.ports) != "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "traefik" ]]; then
  echo "Warning: Traefik deployed with ports open! Server at risk for explotation!" > /pg/data/blitz/emergency/message.a
elif [ -e "/pg/data/blitz/emergency/message.a" ]; then rm -rf /pg/data/blitz/emergency/message.a; fi

if [[ $(cat /pg/var/pg.ports) == "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "" ]]; then
  echo "Warning: Apps Cannot Be Accessed! Ports are Closed & Traefik is not enabled! Either deploy traefik or open your ports (which is worst for security)" > /pg/data/blitz/emergency/message.b
elif [ -e "/pg/data/blitz/emergency/message.b" ]; then rm -rf /pg/data/blitz/emergency/message.b; fi
##### Warning for Bad Traefik Deployment - message.c is tied to traefik showing a status! Do not change unless you know what your doing
touch /pg/data/blitz/traefik.check
domain=$(cat /pg/var/server.domain)
wget -q "https://portainer.${domain}" -O "/pg/data/blitz/traefik.check"
if [[ $(cat /pg/data/blitz/traefik.check) == "" && $(docker ps --format '{{.Names}}' | grep traefik) == "traefik" ]]; then
  echo "Traefik is Not Deployed Properly! Cannot Reach the Portainer SubDomain!" > /pg/data/blitz/emergency/message.c
else
  if [ -e "/pg/data/blitz/emergency/message.c" ]; then
  rm -rf /pg/data/blitz/emergency/message.c; fi
fi
##### Warning for Traefik Rate Limit Exceeded
if [[ $(cat /pg/data/blitz/traefik.check) == "" && $(docker logs traefik | grep "rateLimited") != "" ]]; then
  echo "$domain's rated limited exceed | Traefik (LetsEncrypt)! Takes upto one week to clear up (or use a new domain)" > /pg/data/blitz/emergency/message.d
else
  if [ -e "/pg/data/blitz/emergency/message.d" ]; then
  rm -rf /pg/data/blitz/emergency/message.d; fi
fi

################# Generate Output
echo "" > /pg/var/emergency.log

if [[ $(ls /pg/data/blitz/emergency) != "" ]]; then
countmessage=0
while read p; do
  let countmessage++
  echo -n "${countmessage}. " >> /pg/var/emergency.log
  echo "$(cat /pg/data/blitz/emergency/$p)" >> /pg/var/emergency.log
done <<< "$(ls /pg/data/blitz/emergency)"
else
  echo "NONE" > /pg/var/emergency.log
fi

sleep 5
done
