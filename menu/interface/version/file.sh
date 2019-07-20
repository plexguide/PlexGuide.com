#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
rm -rf /var/plexguide/ver.temp 1>/dev/null 2>&1
touch /var/plexguide/ver.temp

sleep 4
## Builds Version List for Display
while read p; do
  echo $p >>/var/plexguide/ver.temp
done </opt/plexguide/menu/interface/version/version.sh

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG Update Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

cat /var/plexguide/ver.temp
echo ""
echo "[Z] Exit"
echo ""
break=no
while [ "$break" == "no" ]; do
  read -p '↘️  Type [PG Version] | PRESS ENTER: ' typed
  storage=$(grep $typed /var/plexguide/ver.temp)

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    echo ""
    touch /var/plexguide/exited.upgrade
    exit
  fi

  if [ "$storage" != "" ]; then
    break=yes
    echo $storage >/var/plexguide/pg.number
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
