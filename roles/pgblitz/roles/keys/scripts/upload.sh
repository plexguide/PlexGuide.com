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
  echo 'INFO - PGBlitz: Using GDSA $p for transfer' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  mkdir -p /mnt/pgblitz/$p
  mv /mnt/move/* /mnt/pgblitz/$p
  echo "INFO - PGBlitz: Moved Items /mnt/move to /mnt/pgblitz/$p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "INFO - PGBlitz: Starting PGBlitz Transfer Using $p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ls -la /mnt/pgblitz/$p
  echo "sleep 3"
  rclone move --tpslimit 6 --checkers=20 \
    --config $rpath \
    --transfers=8 \
    --exclude="**partial~" --exclude="**_HIDDEN~" \
    --exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
    --drive-chunk-size=32M \
    /mnt/pgblitz/$p $p:
    rm -r /mnt/pgblitz/$p
    echo "$p - GDSA"
    echo "INFO - PGBlitz: '$p' - Transfer Complete" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    sleep 10
done </tmp/pg.gdsa
