#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

mainstart () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Box Apps Interface Selection       📓 Reference: pgbox.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  PG Box installs a series of Core and Community applications!

[1] PG Box: Core
[2] PG Box: Community
[3] PG Box: Removal
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/pgbox/pgboxcore.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/pgbox/pgboxcommunity.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/removal/removal.sh
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
exit
else
mainstart
fi
}

mainstart
