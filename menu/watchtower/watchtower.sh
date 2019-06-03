#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
watchtower () {

if [[ "$easy" != "on" ]]; then

  file="/pg/var/watchtower.wcheck"
  if [ ! -e "$file" ]; then
  echo "4" > /pg/var/watchtower.wcheck
  fi

  wcheck=$(cat "/pg/var/watchtower.wcheck")
    if [[ "$wcheck" -ge "1" && "$wcheck" -le "3" ]]; then
    wexit="1"
    else wexit=0; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG WatchTower Edition ~ 📓 Reference: watchtower.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  WatchTower updates your containers soon as possible!

1 - Containers: Auto-Update All
2 - Containers: Auto-Update All Except | Plex & Emby
3 - Containers: Never Update
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Standby
  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    watchtowergen
    ansible-playbook /pg/coreapps/apps/watchtower.yml
    echo "1" > /pg/var/watchtower.wcheck
  elif [ "$typed" == "2" ]; then
    watchtowergen
    sed -i -e "/plex/d" /pg/tmp/watchtower.set 1>/dev/null 2>&1
    sed -i -e "/emby/d" /pg/tmp/watchtower.set 1>/dev/null 2>&1
    ansible-playbook /pg/coreapps/apps/watchtower.yml
    echo "2" > /pg/var/watchtower.wcheck
  elif [ "$typed" == "3" ]; then
    echo null > /pg/tmp/watchtower.set
    ansible-playbook /pg/coreapps/apps/watchtower.yml
    echo "3" > /pg/var/watchtower.wcheck
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    if [ "$wexit" == "0" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️   WatchTower Preference Must be Set Once!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 3
    watchtower
    fi
    exit
  else
  badinput
  watchtower
  fi
else
  # If "easy == on", this results in a quick install of watchtower
  watchtowergen
  ansible-playbook /pg/coreapps/apps/watchtower.yml
  echo "1" > /pg/var/watchtower.wcheck
fi
}

watchtowergen () {
  bash /pg/coreapps/apps/_appsgen.sh
  while read p; do
    echo -n $p >> /pg/tmp/watchtower.set
    echo -n " " >> /pg/tmp/watchtower.set
  done </pg/var/app.list
}
