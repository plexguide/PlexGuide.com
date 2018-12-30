#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
question1 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Shield                       ⚡ Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  PG Shield requires Google Web Auth Keys! Visit the link above!

1. Set Web Client ID & Secret
2. Deploy PG Shiled
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
phase1
}

phase1 () {

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        webid
        phase1 ;;
    2 )
        ansible-playbook /opt/plexguide/menu/pgshield/pgshield.yml
        phase1;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        question1 ;;
esac
}

webid() {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Web Keys - Client ID       📓 Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google Web Auth Keys

EOF

read -p '↘️  Web Client ID     | Press [Enter]: ' public < /dev/tty
if [ "$public" = "exit" ]; then exit; fi
echo "$public" > /var/plexguide/shield.clientid

read -p '↘️  Web Client Secret | Press [Enter]: ' secret < /dev/tty
if [ "$secret" = "exit" ]; then exit; fi
echo "$secret" > /var/plexguide/shield.clientsecret

read -p '🌎 Client ID & Secret Set |  Press [Enter]: ' public < /dev/tty
question1
}

question1
