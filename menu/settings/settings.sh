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
🚀 PG Settings Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Download Path   : Change the Processing Location
2 - Processor       : Enhance the CPU Processing Power
3 - Keneral Modes   : Enhance Network Throughput
4 - WatchTower      : Auto-Update Application Manager
5 - Change Time     : Change the Server Time
6 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/interface/dlpath/main.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/roles/processor/scripts/processor-menu.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/menu/interface/watchtower/file.sh
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
