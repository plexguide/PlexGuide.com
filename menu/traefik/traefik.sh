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
main /var/plexguide/traefik.deploy 'Not Deployed' tld

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Reverse Proxy Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Top Level Domain App: [$tld]
2 - Domain Provider     : [$provider]
3 - Domain Name         : [$domain]
4 - EMail Address       : [$email]
5 - Deploy Traefik      : [FILL]
6 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/interface/dlpath/main.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/traefik/provider.sh
  bash /opt/plexguide/menu/traefik/traefik.sh
  exit
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
elif [ "$typed" == "4" ]; then

  file="/var/plexguide/watchtower.id"
  if [ -e "$file" ]; then
    rm -r /var/plexguide/watchtower.id
  fi
  bash /opt/plexguide/menu/watchtower/watchtower.sh

elif [ "$typed" == "5" ]; then
  dpkg-reconfigure tzdata
elif [ "$typed" == "6" ]; then
  exit
else
  bash /opt/plexguide/menu/settings/settings.sh
  exit
fi

bash /opt/plexguide/menu/settings/settings.sh
exit
