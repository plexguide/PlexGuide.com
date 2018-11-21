#!/bin/bash
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
################################################################################

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /tmp/program_var)
mkdir -p /var/plexguide/cron/
mkdir -p /opt/appdata/plexguide/cron
# FUNCTIONS START ##############################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty

}

ports=$(cat /var/plexguide/server.ports)

if [ "$ports" == "127.0.0.1:" ]; then guard=CLOSED && opp=Open;
else guard=OPEN & opp=Close; fi

# FIRST QUESTION
question1 () {
space=$(cat /var/plexguide/data.location)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to PortGuard!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://portguard.plexguide.com

Ports Are Currently: [$guard]

1. [$open] Ports
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    if [ "$guard" == "CLOSED" ]; then echo "" > /var/plexguide/server.ports
  else; then echo "127.0.0.1:" > /var/plexguide/server.ports
    bash /opt/plexguide/menu/portguard/rebuild.sh
    fi
  fi
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then exit;
else badinput; fi
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done

#serverip=$(cat /opt/appdata/plexguide/server.info | tail -n +3 | head -n 1 | cut -d " " -f2-)
#initialpw=$(cat /opt/appdata/plexguide/server.info | tail -n +4 | cut -d " " -f3-)
#check=$(hcloud server list | grep "\<$sshin\>" | cut -d " " -f2- | cut -d " " -f2- | cut -d " " -f2-)
#ipcheck=$(echo $check | awk '{ print $3 }')
#⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
# read -n 1 -s -r -p "Press [ANY] Key to Continue "
