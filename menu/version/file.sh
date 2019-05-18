#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
mainstart() {
echo ""
echo "💬  Pulling Update Files - Please Wait"
file="/opt/pgstage/place.holder"
waitvar=0
while [ "$waitvar" == "0" ]; do
	sleep .5
	if [ -e "$file" ]; then waitvar=1; fi
done

pgnumber=$(cat "/pg/var/pg.number")
latest=$(cat "/opt/pgstage/versions.sh" | head -n1)
beta=$(cat /opt/pgstage/versions.sh | sed -n 2p)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG Update Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Prior Versions? Visit > versions.pgblitz.com

Lastest:  : $latest
Beta      : $beta
Installed : $pgnumber

Quitting? TYPE > exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

break=no
read -p '🌍  TYPE a PG Version | PRESS ENTER: ' typed
storage=$(grep $typed /opt/pgstage/versions.sh)

parttwo
}

parttwo() {
if [[ "$typed" == "exit" || "$typed" == "EXIT" || "$typed" == "Exit" ]]; then
  echo ""; touch /pg/var/exited.upgrade; exit; fi

if [ "$storage" != "" ]; then
  break=yes
  echo $storage > /pg/var/pg.number
  ansible-playbook /opt/plexguide/menu/version/choice.yml

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  SYSTEM MESSAGE: Installing Verison - $typed - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
touch /pg/var/new.install

file="/pg/var/community.app"
if [ -e "$file" ]; then rm -rf /pg/var/community.app; fi

exit
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  SYSTEM MESSAGE: Version $typed does not exist! - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 2
  mainstart
fi
}

rm -rf /opt/pgstage
mkdir -p /opt/pgstage
ansible-playbook /opt/plexguide/menu/pgstage/pgstage.yml #&>/de v/null &
mainstart
