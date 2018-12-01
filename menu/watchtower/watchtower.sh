#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
file="/var/plexguide/watchtower.id"
  if [ ! -e "$file" ]; then
    echo "Checked" > /var/plexguide/watchtower.id
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
    echo "SET" > /var/plexguide/watchtower.id
elif [ "$typed" == "2" ]; then
  sed -i -e "/plex/d" /tmp/watchtower.set 1>/dev/null 2>&1
  sed -i -e "/emby/d" /tmp/watchtower.set 1>/dev/null 2>&1
  ansible-playbook /opt/plexguide/containers/watchtower.yml
  echo "SET" > /var/plexguide/watchtower.id
elif [ "$typed" == "3" ]; then
  echo null > /tmp/watchtower.set
  ansible-playbook /opt/plexguide/containers/watchtower.yml
  echo "SET" > /var/plexguide/watchtower.id
elif [[ "$typed" == "Z" && "$typed" != "z" ]]; then
exit
fi
