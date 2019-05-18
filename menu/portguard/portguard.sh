#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq - Sub7Seven
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /pg/tmp/program_var)
mkdir -p /pg/var/cron/
mkdir -p /pg/data/blitz/cron
# FUNCTIONS START ##############################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty

}

# FIRST QUESTION
question1 () {
ports=$(cat /pg/var/server.ports)
if [ "$ports" == "127.0.0.1:" ]; then guard="CLOSED" && opp="Open";
else guard="OPEN" && opp="Close"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 Welcome to PortGuard!             📓 Reference: portguard.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ports Are Currently: [$guard]

1. $opp Ports
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    if [ "$guard" == "CLOSED" ]; then echo "" > /pg/var/server.ports
  else echo "127.0.0.1:" > /pg/var/server.ports; fi
    bash /opt/plexguide/menu/portguard/rebuild.sh
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then exit;
else badinput; fi
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
