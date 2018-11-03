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
📂  PG Data Transport Systems
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - PG Move   | Unencrypt & Encrypt | 750 GB Daily Upload | Simple
2 - PG Blitz  | Unencrypted         | 15  TB Daily Upload | Complex
3 - PG Drives | Unencrypted         | Read Only Servers   | Simple
4 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/interface/apps/move.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/interface/apps/drives.sh
elif [ "$typed" == "4" ]; then
  exit
else
  bash /opt/plexguide/menu/transport/transport.sh
  exit
fi

bash /opt/plexguide/menu/transport/transport.sh
exit
