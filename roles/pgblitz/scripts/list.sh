#!/bin/bash
#
# [Ansible Role]
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
echo "INFO - PGBlitz: Starting JSON Building Process" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
number=0

### Remove Files for the Process
rm -r /tmp/pg.keys.processed.count 1>/dev/null 2>&1

### Initial List of Unprocessed Keys
ls -la /opt/appdata/pgblitz/keys/unprocessed | awk '{ print $9}' | tail -n +4 > /tmp/pg.ukeys.temp

### Initial List of Processed Keys
ls -la /opt/appdata/pgblitz/keys/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.pkeys.temp

### Make Temp Directory To Move Temp-Processed Keys
mkdir -p /opt/appdata/pgblitz/keys/temp 1>/dev/null 2>&1

while read p; do
  p=${p:4}
  echo $p >> /tmp/pg.keys.processed.count
done </tmp/pg.pkeys.temp

while read p; do
  let "number++"
  until [ "$break" == "1" ]; do
    check=$(grep -w "$number" /tmp/pg.keys.processed.count)
    if [ "$check" == "$number" ]; then
        break=0
        let "number++"
        echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      else
        break=1
    fi
  done

  mv /opt/appdata/pgblitz/keys/unprocessed/$p /opt/appdata/pgblitz/keys/temp/GDSA$number
  #echo "/opt/appdata/pgblitz/keys/unprocessed/$p" > /opt/appdata/pgblitz/keys/originalname/GDSA$number
  #echo "INFO - PGBlitz: GDSA$number Established" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done </tmp/pg.ukeys.temp

mv /opt/appdata/pgblitz/keys/temp/* /opt/appdata/pgblitz/keys/unprocessed/

echo "INFO - PGBlitz: JSON Building Process List Complete" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
