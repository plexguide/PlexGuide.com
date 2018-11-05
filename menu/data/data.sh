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

# Touch Variables Incase They Do Not Exist
file="/var/plexguide/restore.id"
if [ ! -e "$file" ]; then
  echo "[NOT-SET]" > /var/plexguide/restore.id
fi

# Call Variables
serverid=$(cat /var/plexguide/pg.serverid)
restoreid=$(cat /var/plexguide/restore.id)

# Simple Check
function restorecheck {
  if [ "$restoreid" == "[NOT-SET]" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - You Must Set Your Recovery ID First! Restarting Process!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo
  bash /opt/plexguide/menu/data/data.sh
exit
  fi
}

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
🍕  PG Data Handling - Server: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

☑️   [Restore ID] server to recover from and [Change Backup Location]
is where you backups will process (stats of current location below).
Note a 100TB Plex Library can create 40GB of MetaData!

🌵  Used Space: $used of $capacity | $percentage Used Capacity

1 - SOLO: App Backup
2 - SOLO: App Restore
3 - MASS: App Backup
4 - MASS: App Restore
5 - Change Current ID: $serverid
6 - Change Restore ID: $restoreid
7 - Change Backup Location: $space
8 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/data/sbackup/sbackup.sh
elif [ "$typed" == "2" ]; then
  restorecheck
  bash /opt/plexguide/menu/data/srestore/srestore.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/data/mbackup/mbackup.sh
elif [ "$typed" == "4" ]; then
  restorecheck
  bash /opt/plexguide/menu/data/mrestore/mrestore.sh
elif [ "$typed" == "5" ]; then
  # Why Here? Located Here for When User Installs PG
  echo "0" > /var/plexguide/server.id
  bash /opt/plexguide/install/serverid.sh
elif [ "$typed" == "6" ]; then
  bash /opt/plexguide/menu/data/restoreid.sh
elif [ "$typed" == "7" ]; then
  bash /opt/plexguide/menu/data/location.sh
elif [ "$typed" == "8" ]; then
  exit
else
  bash /opt/plexguide/menu/data/data.sh
  exit
fi

bash /opt/plexguide/menu/data/data.sh
exit
