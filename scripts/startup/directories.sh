#!/bin/bash

################### For PlexDrive

  mkdir -p /opt/plexguide-startup 1>/dev/null 2>&1
  chmod 755 /opt/plexguide-startup 1>/dev/null 2>&1

################### For SAB

  mkdir -p /mnt 1>/dev/null 2>&1
  mkdir -p /mnt/sab/admin 1>/dev/null 2>&1
  mkdir -p /mnt/sab/incomplete 1>/dev/null 2>&1
  mkdir -p /mnt/sab/complete/tv 1>/dev/null 2>&1
  mkdir -p /mnt/sab/complete/movies 1>/dev/null 2>&1
  mkdir -p /mnt/sab/complete/music 1>/dev/null 2>&1
  mkdir -p /mnt/sab/nzb 1>/dev/null 2>&1

#################### For NZBGET

  mkdir -p /mnt/nzbget 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/incomplete 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/completed/tv 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/completed/movies 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/completed/music 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/nzb 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/tmp 1>/dev/null 2>&1
  mkdir -p /mnt/nzbget/queue 1>/dev/null 2>&1

########################################################### RClone

mkdir -p /mnt/move 1>/dev/null 2>&1
mkdir -p /mnt/gdrive 1>/dev/null 2>&1
mkdir -p /mnt/unionfs 1>/dev/null 2>&1
mkdir -p /mnt/plexdrive4 1>/dev/null 2>&1
mkdir -p /opt/appdata/plexguide 1>/dev/null 2>&1
mkdir -p /mnt/plexdrive4 1>/dev/null 2>&1

bash /opt/plexguide/scripts/startup/owner.sh 1>/dev/null 2>&1
