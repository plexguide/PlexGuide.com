#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty

}

badinput2() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty
  question1
}

question1() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG - PGBlitz Installer ~ http://plex.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: DO NOT SELECT LOCAL SYSTEM for a REMOTE SERVER outside of your
network as in using Hetzner, Google GCE, WholeSale Internet & Etc! If you
do you, it will not work and you will have to uninstall it!

[1] Plex Remote System ~ OUTSIDE your LOCAL NETWORK (i.e 3rd Party)
[2] Plex Local System  ~ INSIDE  your LOCAL NETWORK (i.e Home)
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty
  echo ""
  if [ "$typed" == "1" ]; then
    echo remote >/var/plexguide/plex.server && question3
  elif [ "$typed" == "2" ]; then
    echo local >/var/plexguide/plex.server
  elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
    exit
  else badinput2; fi
}

# THIRD QUESTION
question3() {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Remote Plex Server - Claim the Plex Server
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To Claim the Plex Server, visit https://www.plex.tv/claim/ and input the
code below! You have 5 minutes to do so!

If you are reinstalling plex with existing appdata press enter to skip 
this step as you won't need to claim it again.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Plex Server Claim Number | Press [ENTER]: ' typed </dev/tty
  echo $typed >/var/plexguide/plex.claim && break=on
}

# FUNCTIONS END ##############################################################

question1
#ansible-playbook /opt/coreapps/apps/plex.yml
