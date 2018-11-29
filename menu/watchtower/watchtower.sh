#!/usr/bin/env python3
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
file="/var/plexguide/watchtower.id"
  if [ ! -e "$file" ]; then
    echo NOT-SET > /var/plexguide/watchtower.id
  else
    exit
  fi

wcheck=$(cat /var/plexguide/watchtower.id)

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG WatchTower Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  NOTE: WatchTower updates your containers soon as possible!

1 - Containers: Auto-Update All
2 - Containers: Auto-Update All Except | Plex & Emby
3 - Containers: Never Update
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

rm -r /tmp/watchtower.set 1>/dev/null 2>&1
touch /tmp/watchtower.set

bash /opt/plexguide/containers/_appsgen.sh
while read p; do
  echo -n $p >> /tmp/watchtower.set
  echo -n " " >> /tmp/watchtower.set
done </var/plexguide/app.list
  if [ "$typed" == "1" ]; then
    ansible-playbook /opt/plexguide/containers/watchtower.yml
elif [ "$typed" == "2" ]; then
  sed -i -e "/plex/d" /tmp/watchtower.set 1>/dev/null 2>&1
  sed -i -e "/emby/d" /tmp/watchtower.set 1>/dev/null 2>&1
  ansible-playbook /opt/plexguide/containers/watchtower.yml
elif [ "$typed" == "3" ]; then
  echo null > /tmp/watchtower.set
  ansible-playbook /opt/plexguide/containers/watchtower.yml
elif [[ "$typed" == "4" && "$wcheck" != "NOT-SET" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Must Make a Selection (On New PG Installs)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 5
    rm -rf /var/plexguide/watchtower.id
    bash /opt/plexguide/menu/watchtower/watchtower.sh
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Invalid Selection! Make a Proper Choice!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
sleep 5
  bash /opt/plexguide/menu/watchtower/watchtower.sh
  exit
fi
