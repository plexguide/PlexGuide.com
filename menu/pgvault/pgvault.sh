#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/pgvault.func

initial
apprecall
primaryinterface
# Touch Variables Incase They Do Not Exist
file="/var/plexguide/restore.id"
if [ ! -e "$file" ]; then
  echo "[NOT-SET]" > /var/plexguide/restore.id
fi

# Simple Check
function restorecheck {
  if [ "$restoreid" == "[NOT-SET]" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - You Must Set Your Recovery ID First! Restarting Process!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo
  bash /opt/plexguide/menu/pgvault/pgvault.sh
exit
  fi
}
