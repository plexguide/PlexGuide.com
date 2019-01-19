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
function gcheck {

edition=$(cat /var/plexguide/pg.edition)
if [ "$edition" == "PG Edition - GDrive" ] || [ "$edition" == "PG Edition - GCE Feed" ]; then
gcheck=$(cat /opt/appdata/plexguide/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8)
  if [ "$gcheck" != "[gdrive]" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: You must deploy PG Move or PG Blitz in order to use the backup
function. GDrive configuration is required to move data!

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo
bash /opt/plexguide/menu/tools/tools.sh
exit
  fi
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Backup is Only for GDrive / GCE Editions
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If backing up your files, they are located at the folllowing
location: /opt/appdata

You're on OWN because it's too complex for PG to standardize a backup.
Example, you may have a second hard drive, may store it to the same
drive, a NAS... (kind of hard to account for all the situations).
Think you get the idea!

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo
bash /opt/plexguide/menu/tools/tools.sh
exit
fi
}

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Tools Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] PG Patrol
[2] PG Scan   [Not Ready]
[3] PG Trakt
[4] Personal VPN Service Installer
[5] System & Network Auditor
[6] TroubleShoot ~ PreInstaller
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  bash /opt/plexguide/menu/pgpatrol/pgpatrol.sh
elif [ "$typed" == "2" ]; then
  bash /opt/plexguide/menu/pgscan/pgscan.sh
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/pgtrakt/pgtrakt.sh
elif [ "$typed" == "4" ]; then
  echo 'vpnserver' > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/network/network.sh
elif [ "$typed" == "6" ]; then
  bash /opt/plexguide/menu/tshoot/tshoot.sh
elif [ "$typed" == "Z" ] || [ "$typed" == "z" ]; then
  exit
else
  bash /opt/plexguide/menu/tools/tools.sh
  exit
fi

bash /opt/plexguide/menu/tools/tools.sh
exit
