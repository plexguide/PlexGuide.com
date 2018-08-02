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
echo "INFO - PGBlitz: Starting Validation Process" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

ls -la /opt/appdata/pgblitz/keys/unprocessed | awk '{ print $9}' | tail -n +4 > /tmp/pg.keys.temp

mkdir -p /opt/pgops 1>/dev/null 2>&1
mkdir -p /mnt/tdrive/plexguide/checks 1>/dev/null 2>&1
tdrive=$( cat /root/.config/rclone/rclone.conf | grep team_drive | head -n1 )
tdrive="${tdrive:13}"

clear
echo "Welcome to PG Blitz"
echo "Starting Validation Process"
while read p; do
#  p=$(echo "${p::-1}")
echo ""
echo "Testing JSON: $p"
echo "INFO - PGBlitz: Valdating GDSATEST - $p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

rm -r /root/.config/rclone/rclone.tmp 1>/dev/null 2>&1

tee "/root/.config/rclone/rclone.tmp" > /dev/null <<EOF
[GDSATEST]
type = drive
client_id =
client_secret =
scope = drive
root_folder_id =
service_account_file = /opt/appdata/pgblitz/keys/unprocessed/$p
team_drive = $tdrive
EOF

mkdir -p /opt/pgops/GDSATEST
touch /opt/pgops/GDSATEST/$p

rclone move --tpslimit 6 --checkers=20 \
  --config /root/.config/rclone/rclone.tmp \
  --transfers=8 \
  --log-file=/opt/appdata/pgblitz/rclone.log --log-level INFO --stats 10s \
  --exclude="**partial~" --exclude="**_HIDDEN~" \
  --exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
  --drive-chunk-size=32M \
  /opt/pgops/GDSATEST GDSATEST:plexguide/checks && rclone_fin_flag=1

echo "Waiting 2 Seconds"
sleep 2.5

checker=$(rclone lsf \
  --config /root/.config/rclone/rclone.tmp \
GDSATEST:plexguide/checks/ | grep "$p")

  if [ "$p" == "$checker" ]; then
      GREEN='\033[0;32m'
      NC='\033[0m'
      echo -e "JSON: $checker - ${GREEN}VALID${NC}"
      echo "INFO - PGBlitz: GDSATEST - $p is good!" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      mv /opt/appdata/pgblitz/keys/unprocessed/$p /opt/appdata/pgblitz/keys/processed/
    else
      RED='\033[0;31m'
      NC='\033[0m'
      echo -e "JSON: $checker - Sending to /opt/appdata/pgblitz/keys/badjson/ - ${RED}INVALID${NC}"
      echo "INFO - PGBlitz: $p is a bad JSON File - Sending Bad JSON to /opt/appdata/pgblitz/keys/badjson" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      mv /opt/appdata/pgblitz/keys/unprocessed/$p /opt/appdata/pgblitz/keys/badjson/ 1>/dev/null 2>&1
      rm -r /mnt/tdrive/plexguide/checks/$p 1>/dev/null 2>&1
  fi

done </tmp/pg.keys.temp

echo "INFO - PGBlitz: Finished Validating JSON Files" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
echo "" && echo "Finished Valadating JSON Files" && read -n 1 -s -r -p "Press any key to continue"

rm -r /opt/pgops/GDSATEST 1>/dev/null 2>&1
