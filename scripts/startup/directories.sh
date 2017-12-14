#!/bin/bash

################### For PlexDrive

  mkdir -p /opt/plexguide-startup 1>/dev/null 2>&1
  chmod 755 /opt/plexguide-startup 1>/dev/null 2>&1

################### For SAB

  mkdir -p /home/plexguide 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/admin 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/incomplete 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/complete/tv 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/complete/movies 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/nzb 1>/dev/null 2>&1

#################### For NZBGET

  mkdir -p /home/plexguide/nzbget 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/incomplete 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/completed/tv 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/completed/movies 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/nzb 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/tmp 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/queue 1>/dev/null 2>&1

########################################################### RClone

mkdir -p /home/plexguide/move 1>/dev/null 2>&1
mkdir -p /home/plexguide/gdrive 1>/dev/null 2>&1
mkdir -p /home/plexguide/unionfs 1>/dev/null 2>&1
mkdir -p /home/plexguide/plexdrive4 1>/dev/null 2>&1
mkdir -p /opt/appdata/plexguide 1>/dev/null 2>&1
mkdir -p /home/plexguide/plexdrive4 1>/dev/null 2>&1

bash /opt/plexguide/scripts/startup/owner.sh 1>/dev/null 2>&1
