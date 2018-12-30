#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
question1 () {

  touch /var/plexguide/pgshield.emails

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Shield                       ⚡ Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  PG Shield requires Google Web Auth Keys! Visit the link above!

1. Set Web Client ID & Secret
2.
3. Deploy PG Shiled
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
        email
        phase1;;
    3 )
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

read -p '🌎 Client ID & Secret Set |  Press [ENTER] ' public < /dev/tty
question1
}

email() {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Shield - Trusted Users        ⚡ Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. E-Mail: Add User
2. E-Mail: Remove User
3. E-Mail: View Current Users
4. E-Mail: Delete All Users
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
phase2
}

phase2 () {

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        echo
        read -p 'User Email to Add | Press [ENTER]: ' typed < /dev/tty
        echo -n "$typed," >> /var/plexguide/pgshield.emails
        email ;;
    2 )
        echo
        read -p 'User Email to Remove | Press [ENTER]: ' typed < /dev/tty
        echo "$typed," >> /var/plexguide/pgshield.emails
        email ;;
    3 )
        echo "Current Stored E-Mail Address"
        echo ""
        cat /var/plexguide/pgshield.emails
        email ;;
    4 )
        rm -r /var/plexguide/pgshield.emails
        touch /var/plexguide/pgshield.emails
        email ;;
    z )
        question1 ;;
    Z )
        question1 ;;
    * )
        email ;;
esac
}

question1
