#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
program=$(cat /pg/tmp/program_var)
domain=$(cat /pg/var/server.domain)
port=$(cat /pg/tmp/program_port)
ip=$(cat /pg/var/server.ip)
ports=$(cat /pg/var/server.ports)

if [ "$program" == "plex" ]; then extra="/web"; else extra=""; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💎 Access Configuration Info > http://$program.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

tee <<-EOF
▫ $program:${port} <- Traefik URL (Internal App-to-App)
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

First Time Plex Claim Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
if [ "$domain" != "NOT-SET" ]; then
tee <<-EOF
▫ http://plex.${domain}:32400 <-- Use http; not https
EOF
fi

tee <<-EOF
▫ $ip:${port}${extra}
EOF
fi
