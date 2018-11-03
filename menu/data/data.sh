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
touch /var/plexguide/pg.serverid

# Call Variables
serverid=$(cat /var/plexguide/pg.serverid)

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍕  PG Data Handling - Server: $serverid | Recovery:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Current Server ID is well... your current server! The RECOVERY ID
is the server you want to recover from! Makes sense right?

1 - SOLO: App Backup
2 - SOLO: App Recovery
3 - MASS: App Backup
4 - MASS: App Restore
5 - Change Current  ID: $serverid
6 - Change Recovery ID:
7 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/data/sbackup/sbackup.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/data/srestore/srestore.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/data/mbackup/mbackup.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/menu/data/mrestore/mrestore.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/
elif [ "$typed" == "6" ]; then
  bash /opt/plexguide
elif [ "$typed" == "7" ]; then
  exit
else
  bash /opt/plexguide/menu/data/data.sh
  exit
fi

bash /opt/plexguide/menu/data/data.sh
exit
