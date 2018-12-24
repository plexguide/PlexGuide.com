#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# wait for place.holder to show up
placeholder=0
while [ "$placeholder" == "0" ]; do
  file="/opt/pgstage/place.holder"
  if [ -e "$file" ]; then
  echo placeholder="1"; fi
done

## Builds Version List for Display
while read p; do
  echo $p >> /var/plexguide/ver.temp
done </opt/plexguide/menu/interface/version/version.sh
latest=$(cat /opt/pgstage/versions.sh | head -n1)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG Update Interface Menu    📓 Reference: http://update.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬  Visit http://versions.plexguide.com the list of prior PG Versions

✅  Latest Version: $latest

💍  [EDGE] - Not recommended (for testing)
7.6edge

EOF

cat /opt/plexguide/version.sh
#cat /var/plexguide/ver.temp
echo ""
echo "To QUIT, type >>> exit"
break=no
while [ "$break" == "no" ]; do
read -p '↘️  Type [PG Version] | PRESS ENTER: ' typed
storage=$(grep $typed /var/plexguide/ver.temp)

if [ "$typed" == "exit" ]; then
  echo ""
  touch /var/plexguide/exited.upgrade
  exit
fi

if [ "$storage" != "" ]; then
  break=yes
  echo $storage > /var/plexguide/pg.number
  ansible-playbook /opt/plexguide/menu/interface/version/choice.yml

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  SYSTEM MESSAGE: Installed Verison - $storage - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 4
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  SYSTEM MESSAGE: Version $storage does not exist! - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 4
  cat /var/plexguide/ver.temp
  echo ""
fi

done
