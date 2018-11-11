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

# Create Variables (If New) & Recall
variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

# For ZipLocations

variable /var/plexguide/server.hd.path "/mnt"
pgpath=$(cat /var/plexguide/server.hd.path)

used=$(df -h $pgpath | tail -n +2 | awk '{print $3}')
capacity=$(df -h $pgpath | tail -n +2 | awk '{print $2}')
percentage=$(df -h $pgpath | tail -n +2 | awk '{print $5}')
###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Processing Disk Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵  Processing Disk : $pgpath
    Processing Space: $used of $capacity | $percentage Used Capacity

NOTE: PG does not format your second disk, nor mount it! We can
only assist by changing the location path!

Purpose: Enables PG System to process items on a SECONDARY Drive rather
than tax the PRIMARY DRIVE. Like Windows, you can have your items
process on a (D): Drive instead of on a (C): Drive.

Do You Want To Change the Processing Disk?

[1] No
[2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Standby
read -p '↘️   Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then

    if [ "$edition" == "PG Edition - GDrive" ]; then bash /opt/plexguide/menu/transport/transport.sh
    elif [ "$edition" == "PG Edition - GCE Feed" ]; then bash /opt/plexguide/menu/transport/transport.sh
    elif [ "$edition" == "PG Edition - HD Multi" ]; then bash /opt/plexguide/menu/multihd/scripts/main.sh
    elif [ "$edition" == "PG Edition - HD Solo" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Using Solo HD Edition! You Cannot Set Mounts! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
     fi

elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/traefik/traefik.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/apps/apps.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/menu/removal/removal.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/tools/tools.sh
elif [ "$typed" == "6" ]; then
  bash /opt/plexguide/menu/settings/settings.sh
elif [ "$typed" == "7" ]; then
  bash /opt/plexguide/roles/ending/ending.sh
  exit
else
  bash /opt/plexguide/menu/start/start.sh
  exit
fi

bash /opt/plexguide/menu/start/start.sh
exit
