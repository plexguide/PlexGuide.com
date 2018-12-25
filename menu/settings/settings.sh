#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Settings Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Download Path:  Change the Processing Location
[2] Processor    :  Enhance the CPU Processing Power
[3] WatchTower   :  Auto-Update Application Manager
[4] Change Time  :  Change the Server Time
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/dlpath/dlpath.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/processor/processor.sh
elif [ "$typed" == "3" ]; then
  watchtower
elif [ "$typed" == "4" ]; then
  dpkg-reconfigure tzdata
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
  exit
else
  bash /opt/plexguide/menu/settings/settings.sh
  exit
fi

bash /opt/plexguide/menu/settings/settings.sh
exit
