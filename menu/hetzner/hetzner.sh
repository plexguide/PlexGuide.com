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

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG - Hetzner's Cloud Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

* SSH Key's
  1 - Generate SSH Key
  2 - Recall Key for Hetzner

* Servers
  3 - Deploy a New Server
  4 - List Server(s)
  5 - Destory a Server

6 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  gcheck
  bash /opt/plexguide/menu/data/data.sh
elif [ "$typed" == "2" ]; then
  echo gce > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/roles/menu-ports/scripts/main.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/roles/menu-appguard/scripts/main.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/interface/pgtrak/main.sh
else
  bash /opt/plexguide/menu/tools/tools.sh
  exit
fi


#⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
# read -n 1 -s -r -p "Press [ANY] Key to Continue "
