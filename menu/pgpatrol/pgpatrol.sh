#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/plexguide/pgpatrol
touch /var/plexguide/pgpatrol/video.number
touch /var/plexguide/pgpatrol/multiple.ips
touch /var/plexguide/pgpatrol/kick.minutes

# FUNCTIONS START ##############################################################

# FIRST FUNCTION
token () {
 ptoken=$(cat /var/plexguide/plex.token)
 if [ "$ptoken" == "" ]; then
   bash /opt/plexguide/menu/plex/token.sh
   ptoken=$(cat /var/plexguide/plex.token)
   if [ "$ptoken" == "" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Failed to Generate a Valid Plex Token! Exiting Deployment!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
    exit; fi; fi
}

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty

}

# FIRST QUESTION
question1 () {

video=$(cat /var/plexguide/pgpatrol/video.transcodes)
ips=$(cat /var/plexguide/pgpatrol/multiple.ips)
minutes=$(cat /var/plexguide/pgpatrol/kick.minutes)

if [ "$video" == "" ]; then echo "False" > /var/plexguide/pgpatrol/video.transcodes; fi
if [ "$ips" == "" ]; then echo "2" > /var/plexguide/pgpatrol/multiple.ips; fi
if [ "$minutes" == "" ]; then echo "10" > /var/plexguide/pgpatrol/kick.minutes; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Patrol Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://pgpatrol.plexguide.com

1 - Instantly Kick Video Transcodes?              | [$video]
2 - Allowed Multiple IPs for Same User Name?      | [$ips]
3 - Kick Paused Transcode after how many Minutes? | [$minutes]
4 - Deploy PGPatrol [Not Deployed]
Z - EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
#  if [ "$typed" == "1" ]; then ansible-playbook /opt/plexguide/menu/cron/remove.yml && exit;
#elif [ "$typed" == "2" ]; then break="on";
#elif [ "$typed" == "3" ]; then bash /opt/plexguide/menu/data/location.sh && question1;
#elif [ "$typed" == "4" ]; then bash /opt/plexguide/menu/data/location.sh && question1;
#elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then exit; fi

}

# FUNCTIONS END ##############################################################

token
question1
