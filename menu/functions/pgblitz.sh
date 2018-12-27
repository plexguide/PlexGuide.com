#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 & PhysK
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
function log()
{
    echo "[PGBlitz] $@" > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
    echo "[PGBlitz] $@"
}

starter () {
  #Make sure all the folders we need are created
  downloadpath=$(cat /var/plexguide/server.hd.path)
  path=/opt/appdata/pgblitz/keys
  mkdir -p /opt/appdata/pgblitz/pid/
  mkdir -p /opt/appdata/pgblitz/json/
  mkdir -p /opt/appdata/pgblitz/logs/
  mkdir -p /opt/appdata/pgblitz/vars/

  #Header
  log "PGBlitz v2.1 Started"
  log "Started for the First Time - Cleaning up if from reboot"

  # Remove left over webui and transfer files
  rm -f /opt/appdata/pgblitz/pid/*
  rm -f /opt/appdata/pgblitz/json/*
  rm -f /opt/appdata/pgblitz/logs/*
}

stasks () {
  #copy any files that failed to upload back to /mnt/move
  for i in `find /mnt/pgblitz/ -maxdepth 1 -mindepth 1 -type d`; do
      cp -r ${i}/* $downloadpath/move
      rm -fr ${i}/*
  done
  log "Cleaned up - Sleeping 10 secs"
  sleep 10

  #### Generates the GDSA List from the Processed Keys
  GDSAARRAY=(`ls -la $path/processed | awk '{print $9}' | grep gdsa`)
  GDSACOUNT=`expr ${#GDSAARRAY[@]} - 1`

  # Check to see if we have any keys
  if [ $GDSACOUNT -lt 1 ]; then
      log "No accounts found to upload with, Exit"
      exit 1
  fi

  # Check if BC is installed
  if [ `echo "10 + 10" | bc` == "20" ]; then
      log "BC Found! All good :)"
  else
      log "BC Not installed, Exit"
      exit 2
  fi
  # Grabs vars from files
  if [ -e /opt/appdata/pgblitz/vars/lastGDSA ]; then
      GDSAUSE=`cat /opt/appdata/pgblitz/vars/lastGDSA`
      GDSAAMOUNT=`cat /opt/appdata/pgblitz/vars/gdsaAmount`
  else
      GDSAUSE=0
      GDSAAMOUNT=0
  fi
}

finder () {
downloadpath=$(cat /var/plexguide/server.hd.path)

for i in `find $downloadpath/pgblitz/* -maxdepth 1 -mindepth 1 -mmin +30 -type d`; do
    log "Found Stuck Folders/Files ~ ${i}"
    log "Moving ${i} back to /mnt/move for processing"

    file="/var/plexguide/blitz.badkey"
    if [ ! -e "$file" ]; then echo 0 > /var/plexguide/blitz.badkey; fi

    badcount=$(cat /var/plexguide/blitz.badkey)
    ((badcount++))
      if [ "$badcount" -ge "3" ]; then
        badcount="0"
        log "Bad Key Threshold Reach 3 of 3! Switching GDSA Keys!"
        GDSAUSE=`expr $GDSAUSE + 1`
        GDSAAMOUNT=0
        echo 0 > /var/plexguide/blitz.badkey
      else
        GDSAUSE=0
        GDSAAMOUNT=0
        log "Bad Key Count $badcount of 3 Reached! Switching GDSA Keys @ 3!"
        echo $badcount > /var/plexguide/blitz.badkey
      fi
    mv ${i} "$downloadpath/move"
done

}
