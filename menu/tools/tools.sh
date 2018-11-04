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
gcheck=$(cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8)
  if [ "$gcheck" != "[gdrive]" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Must Configure RClone First /w >>> gdrive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: gdrive has to be configured in RClone.  Without it, PG is unable
to send your backups to your Google Drive!

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo
bash /opt/plexguide/menu/tools/tools.sh
exit
  fi
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Backup is Only for GDrive / GCE Editions
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If you want to back up your files, they are located at the
folllowing location: /opt/appdata

Remember, your on your own because you can backup two a second drive,
same drive different location, NAS... think you get the idea.

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo
bash /opt/plexguide/menu/tools/tools.sh
exit
fi
}
# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Tools Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Backup & Restore
2 - Deploy GCE Feeder Instance
3 - PGTrak ~ Fill Up Sonarr & Radarr
4 - Personal VPN Service Installer
5 - System & Network Auditor
6 - TroubleShoot ~ PreInstaller & UnInstaller
7 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  gcheck
  bash /opt/plexguide/menu/data/data.sh
elif [ "$typed" == "2" ]; then
  echo gce > /var/plexguide/type.choice
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/interface/pgtrak/main.sh
elif [ "$typed" == "4" ]; then
  echo 'vpnserver' > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/roles/menu-network/scripts/main.sh
elif [ "$typed" == "6" ]; then
  echo 'tshoot' > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh
elif [ "$typed" == "7" ]; then
  exit
else
  bash /opt/plexguide/menu/tools/tools.sh
  exit
fi

bash /opt/plexguide/menu/tools/tools.sh
exit
