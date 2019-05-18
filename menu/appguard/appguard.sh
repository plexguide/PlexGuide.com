#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /pg/tmp/program_var)
mkdir -p /pg/var/cron/
mkdir -p /pg/data/blitz/cron
# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

# FIRST QUESTION
question1 () {
  appguard=$(cat /pg/var/server.ht)
  if [ "$appguard" == "" ]; then guard="DISABLED" && opp="Enable";
else guard="ENABLED" && opp="Disable"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to AppGuard!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://appguard.pgblitz.com

Currently: [$guard]

1. $opp AppGuard
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    if [ "$guard" == "DISABLED" ]; then
    echo ""
    read -p '↘️ [Type] a USERNAME! | PRESS [ENTER] ' user < /dev/tty
    read -p '↘️ [Type] a PASSWORD! | PRESS [ENTER] ' pw < /dev/tty
    htpasswd -cbs /pg/var/server.ht $user $pw
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  AppGuard - Hashed UserName & Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 3
  else echo "" > /pg/var/server.ht; fi
    bash /opt/plexguide/menu/appguard/rebuild.sh
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then exit;
else badinput1; fi
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
