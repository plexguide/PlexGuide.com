#!/bin/bash
##
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & FlickerRate
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
downloadpath=$(cat /var/plexguide/server.hd.path)

echo "INFO - PGBlitz Started for the First Time - 30 Second Sleep" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
sleep 30
path=/opt/appdata/pgblitz/keys
rpath=/root/.config/rclone/rclone.conf
echo "ignore this error for now - only temp hotfix"
mkdir $downloadpath/move/movies
mkdir $downloadpath/move/tv
chown -R $downloadpath/move/*
echo "ignore the errors above - only temp hotfix"

ls -la /opt/appdata/pgblitz/keys/processed | awk '{print $9}' | grep GDSA > /tmp/pg.gdsalist

while true
do

  while read p; do
if find $downloadpath/move -mindepth 2 -type d | egrep '.*' ; then
    #sets the found folders in the $deletepaths - so only the picked up folders get deleted after moving them to /mnt/pgblitz
    IFS=$'\n' deletepaths=( $(find "/mnt/move" -mindepth 2 -type d) )

    echo "INFO - PGBlitz: Using $p for transfer" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

    mkdir -p $downloadpath/pgblitz/$p
    rclone move $downloadpath/move/ $downloadpath/pgblitz/$p/ --min-age 1m \
          --exclude="**partial~" --exclude="**_HIDDEN~" \
          --exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
          --max-transfer=100G \

    echo "INFO - PGBlitz: Moved Items $downloadpath/move to $downloadpath/pgblitz/$p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    #ls -la $downloadpath/pgblitz/$p

    #sleeping a bit to make sure the files are moved
    sleep 10

    #running through the $deletepaths and only deleting the currently picked up folders to not miss anything
    for d in "${deletepaths[@]}"; do
        #checking if the path contains the hidden unionfs-fuse folder and skips if it does
        if [[ ${d} != *"unionfs-fuse"* ]]; then
            find "$d" -type d -empty -delete
        fi
    done

    echo "INFO - PGBlitz $p Deleting empty folder(s) in $downloadpath/move" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
else
    echo "INFO - PGBlitz $p Their is nothing to move from $downloadpath/move" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi


if find $downloadpath/pgblitz/$p -mindepth 2 -type d | egrep '.*' ; then
    echo "INFO - PGBlitz: Starting PGBlitz Transfer Using $p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      rclone move --tpslimit 6 --checkers=20 \
      --config /root/.config/rclone/rclone.conf \
      --transfers=8 \
      --log-file=/opt/appdata/pgblitz/rclone.log --log-level INFO --stats 10s \
      --exclude="**partial~" --exclude="**_HIDDEN~" \
      --exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
      --drive-chunk-size=32M \
      --delete-empty-src-dirs \
      $downloadpath/pgblitz/$p/ $p: && rclone_fin_flag=1

      cat /opt/appdata/pgblitz/rclone.log | tail -n6 > /opt/appdata/pgblitz/end.log

      echo "INFO - PGBlitz: $p Transfer Complete - Next Transfer Start in 2 Minutes" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

      sleep 120
      for d in "${deletepaths[@]}"; do
        #sleeps 2 second between the rc forget command
        sleep 2
        #strips the /mnt/move/ from the path so only the "important" folders are back and rclone rc throws no errors
        d="$(echo $d | sed 's/\'$downloadpath'\/move//g')"
        #checking if the path contains the hidden unionfs-fuse folder and skips if it does
        if [[ ${d} != *"unionfs-fuse"* ]]; then
            rclone rc vfs/forget dir=$d
            echo "INFO - PGBlitz: $p Resetting folder in tdrive for $downloadpath/move/$d" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        fi
      done

else
    echo "INFO - PGBlitz $p Their is nothing to move from $downloadpath/pgblitz/$p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi

    #resetting the IFS folder for $deletepaths so it wont try and delete already deleted paths on next run
    IFS=" "$'\t\n '

      sleep 5
  done </tmp/pg.gdsalist

done
