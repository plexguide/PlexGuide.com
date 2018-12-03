#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/menu.sh

$part1="PG Data Transport Systems 2"
$part2="
#1 - PG Move   | Unencrypt & Encrypt | 750 GB Daily Upload | Simple
#2 - PG Blitz  | Unencrypted         | 15  TB Daily Upload | Complex
#Z - Exit"

menu2 $part1 $part2 

# Menu Interface
#tee <<-EOF

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#📂  PG Data Transport Systems
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#1 - PG Move   | Unencrypt & Encrypt | 750 GB Daily Upload | Simple
#2 - PG Blitz  | Unencrypted         | 15  TB Daily Upload | Complex
#Z - Exit

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/pgmove/pgmove.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/pgblitz/pgblitz.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/pgdrives/pgdrives.sh
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
  exit
else
  bash /opt/plexguide/menu/transport/transport.sh
  exit
fi

bash /opt/plexguide/menu/transport/transport.sh
exit
