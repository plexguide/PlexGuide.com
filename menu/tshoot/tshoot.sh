#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚥 PG TroubleShoot Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Pre-Installer: Force the Entire Process Again
[2] UnInstaller  : Docker & Running Containers | Force Pre-Install
[3] UnInstaller  : PGBlitz
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

if [ "$typed" == "1" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Resetting the Starting Variables!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  echo "0" >/var/plexguide/pg.preinstall.stored
  echo "0" >/var/plexguide/pg.ansible.stored
  echo "0" >/var/plexguide/pg.rclone.stored
  echo "0" >/var/plexguide/pg.python.stored
  echo "0" >/var/plexguide/pg.docker.stored
  echo "0" >/var/plexguide/pg.docstart.stored
  echo "0" >/var/plexguide/pg.watchtower.stored
  echo "0" >/var/plexguide/pg.label.stored
  echo "0" >/var/plexguide/pg.alias.stored
  echo "0" >/var/plexguide/pg.dep.stored

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ WOOT WOOT - Process Complete! Exit & Restart PGBlitz Now!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 5

elif [ "$typed" == "2" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Uninstalling Docker & Resetting the Variables!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3

  rm -rf /etc/docker
  apt-get purge docker-ce
  rm -rf /var/lib/docker
  rm -rf /var/plexguide/dep*
  echo "0" >/var/plexguide/pg.preinstall.stored
  echo "0" >/var/plexguide/pg.ansible.stored
  echo "0" >/var/plexguide/pg.rclone.stored
  echo "0" >/var/plexguide/pg.python.stored
  echo "0" >/var/plexguide/pg.docstart.stored
  echo "0" >/var/plexguide/pg.watchtower.stored
  echo "0" >/var/plexguide/pg.label.stored
  echo "0" >/var/plexguide/pg.alias.stored
  echo "0" >/var/plexguide/pg.dep

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ WOOT WOOT - Process Complete! Exit & Restart PGBlitz Now!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 5
elif [ "$typed" == "3" ]; then
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Starting the PG UnInstaller
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3

  echo "uninstall" >/var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
  exit
else
  bash /opt/plexguide/menu/tshoot/tshoot.sh
  exit
fi

bash /opt/plexguide/menu/tshoot/tshoot.sh
exit
