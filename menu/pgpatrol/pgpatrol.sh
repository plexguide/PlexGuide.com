#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/plexguide/pgpatrol

# FUNCTIONS START ##############################################################

# FIRST FUNCTION
variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

deploycheck () {
  dcheck=$(systemctl status pgpatrol | grep "\(running\)\>" | grep "\<since\>")
  if [ "$dcheck" != "" ]; then dstatus="DEPLOYED";
else dstatus="NOT DEPLOYED"; fi
}

plexcheck () {
  pcheck=$(docker ps | grep "\<plex\>")
  if [ "$pcheck" == "" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Plex is Not Installed or Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
    exit; fi
}

token () {
 touch /var/plexguide/plex.token
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

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG Patrol Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ Reference: http://pgpatrol.plexguide.com

1 - Instantly Kick Video Transcodes?   [$video]
2 - UserName | Multiple IPs?           [$ips]
3 - Minutes  | Kick Paused Transcode?  [$minutes]
4 - Deploy PGPatrol                    [$dstatus]
Z - EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then ansible-playbook /opt/plexguide/menu/cron/remove.yml && exit;
elif [ "$typed" == "2" ]; then break="on";
elif [ "$typed" == "3" ]; then bash /opt/plexguide/menu/data/location.sh && question1;
elif [ "$typed" == "4" ]; then ansible-playbook /opt/plexguide/menu/pgpatrol/pgpatrol.yml;
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then exit;
else badinput; fi
}

# FUNCTIONS END ##############################################################
plexcheck
token
variable /var/plexguide/pgpatrol/video.transcodes "False"
variable /var/plexguide/pgpatrol/multiple.ips "2"
variable /var/plexguide/pgpatrol/kick.minutes "10"
deploycheck
question1
