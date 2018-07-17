#!/bin/bash
#
# [PlexGuide Menu]
#
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

#Remake another for PGBlitz
#clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudst2 --skip-tags cron

path=/opt/appdata/pgblitz/keys
rpath=/root/.config/rclone/rclone.conf

ls -la $path/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsalist

while read p; do

  p=GDSA15
  mkdir -p /mnt/pgblitz/$p
  touch /mnt/pgblitz/$p/dog.txt
  mv /mnt/move/* /mnt/pgblitz/$p

  ls -la /mnt/pgblitz/$p
  echo "sleep 3"
  rclone move --tpslimit 6 --checkers=20 --config $rpath --transfers=8 /mnt/pgblitz/$p $p:

    echo "$p - GDSA"
    echo "stop"
    sleep 20
done </tmp/pg.gdsa
