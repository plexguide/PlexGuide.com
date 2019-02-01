#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
program=$(cat /tmp/program_var)
domain=$(cat /var/plexguide/server.domain)
port=$(cat /tmp/program_port)
ip=$(cat /var/plexguide/server.ip)
ports=$(cat /var/plexguide/server.ports)

if [ "$program" == "plex" ]; then extra="/web"; else extra=""; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💎 Access Configuration Info > http://$program.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

tee <<-EOF
▫ $program:${port} <- Utilize to Connect Other Apps to this App (Internal Only)
EOF

if [ "$ports" == "" ]; then
tee <<-EOF
▫ $ip:${port}${extra}
EOF
fi

if [ "$domain" != "NOT-SET" ]; then
  if [ "$ports" == "" ]; then
tee <<-EOF
▫ $domain:${port}${extra}
EOF
  fi
tee <<-EOF
▫ $program.$domain${extra}
EOF
fi

if [ "$program" == "plex" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
First Time Plex Claim Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
if [ "$domain" != "NOT-SET" ]; then
tee <<-EOF
▫ http://plex.$domain/{extra} <-- Use http; not https
EOF
fi

tee <<-EOF
▫ $ip:${port}${extra}
EOF
fi
