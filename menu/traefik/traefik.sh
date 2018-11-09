#!/usr/bin/env python3
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
#################################################################################

# Create Variables (If New) & Recall
main() {
   local file=$1 val=$2 var=$3
   [[ -e $file ]] || printf '%s\n' "$val" > "$file"
   printf -v "$var" '%s' "$(<"$file")"
}

main /var/plexguide/traefik.provider NOT-SET provider
main /var/plexguide/server.email NOT-SET email
main /var/plexguide/traefik.domain NOT-SET domain
main /var/plexguide/tld.program NOT-SET tld
main /var/plexguide/traefik.deploy 'Not Deployed' deploy

# Questions
main2() {
   local file=$1 val=$2 var=$3
   echo "$val" "$var"

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  ESTABLISHING: $var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  NOTE: To store required information!

EOF
read -p 'Type Requested Info | Press [ENTER]: ' typed < /dev/tty
echo $typed > $file
}

# Deploy
deploy() {
   local file=$1 val=$2 var=$3
   echo "$val" "$var"

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  ESTABLISHING: $var
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  NOTE: To store required information!

EOF
read -p 'Type Requested Info | Press [ENTER]: ' typed < /dev/tty
echo $typed > $file
}

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Reverse Proxy Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Top Level Domain App: [$tld]
2 - Domain Provider     : [$provider]
3 - Domain Name         : [$domain]
4 - EMail Address       : [$email]
5 - Deploy Traefik      : [$deploy]
6 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/traefik/tld.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/traefik/provider.sh
elif [ "$typed" == "3" ]; then
  main2 /var/plexguide/traefik.domain NOT-SET domain
elif [ "$typed" == "4" ]; then
  main2 /var/plexguide/server.email NOT-SET email

elif [ "$typed" == "5" ]; then

    a="NOT-SET"
    if [ "$tld" == "$a" ] || [ "$provider" == "$a" ] || [ "$domain" == "$a" ] || [ "$email" == "$a" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Cannot Deploy! You Must Set All of the Variables First!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 3
    bash /opt/plexguide/menu/traefik/traefik.sh
    exit; fi

elif [ "$typed" == "6" ]; then
fprovider=$(cat /var/plexguide/traefik.provider)

  if [ "$fprovider" == "cloudflare" ]; then
    deploy /var/plexguide/CLOUDFLARE_EMAIL NOT-SET CLOUDFLARE_EMAIL
    deploy /var/plexguide/CLOUDFLARE_API_KEY NOT-SET CLOUDFLARE_API_KEY
  else
  bash /opt/plexguide/menu/treafik/traefik.sh
  exit
  fi

fi
bash /opt/plexguide/menu/traefik/traefik.sh
exit
