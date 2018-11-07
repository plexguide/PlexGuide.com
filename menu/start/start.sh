#!/bin/bash
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

# Touch Variables Incase They Do Not Exist
touch /var/plexguide/pg.edition
touch /var/plexguide/pg.serverid
touch /var/plexguide/pg.number
touch /var/plexguide/traefik.deployed
touch /var/plexguide/server.ht
touch /var/plexguide/server.ports

# Call Variables
edition=$(cat /var/plexguide/pg.edition)
serverid=$(cat /var/plexguide/pg.serverid)
pgnumber=$(cat /var/plexguide/pg.number)

# Declare Traefik Deployed Docker STate
docker ps --format '{{.Names}}' | grep traefik > /var/plexguide/traefik.deployed
traefik=$(cat /var/plexguide/traefik.deployed)
if [ "$traefik" == "" ]; then
  traefik="NOT DEPLOYED"
else
  traefik="DEPLOYED"
fi

# Declare Ports State
ports=$(cat /var/plexguide/server.ports)
if [ "$ports" == "" ]; then
  ports="OPEN"
else
  ports="CLOSED"
fi

# Declare AppGuard State
appguard=$(cat /var/plexguide/server.ht)
if [ "$appguard" == "" ]; then
  appguard="NOT DEPLOYED"
else
  appguard="DEPLOYED"
fi

# For ZipLocations
file="/var/plexguide/data.location"
if [ ! -e "$file" ]; then
  echo "/opt/appdata/plexguide" > /var/plexguide/data.location
fi

space=$(cat /var/plexguide/data.location)
# To Get Used Space
used=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $3}')
# To Get All Space
capacity=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $2}')
# Percentage
percentage=$(df -h /opt/appdata/plexguide | tail -n +2 | awk '{print $5}')

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  $edition - $pgnumber - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵  PG Disk Used Space: $used of $capacity | $percentage Used Capacity

1 - Mounts & Data Transports
2 - Traefik & TLD Deployment [$traefik]
3 - Server Port Guard        [$ports]
4 - Application Guard        [$appguard]
5 - Programs Suite Installer
6 - Tools & Services
7 - Settings
8 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/transport/transport.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/interface/traefik/main.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/roles/menu-ports/scripts/main.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/roles/menu-appguard/scripts/main.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/apps/apps.sh
elif [ "$typed" == "6" ]; then
  bash /opt/plexguide/menu/tools/tools.sh
elif [ "$typed" == "7" ]; then
  bash /opt/plexguide/menu/settings/settings.sh
elif [ "$typed" == "8" ]; then
  bash /opt/plexguide/roles/ending/ending.sh
  exit
else
  bash /opt/plexguide/menu/start/start.sh
  exit
fi

bash /opt/plexguide/menu/start/start.sh
exit
