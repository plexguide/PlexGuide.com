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
#apprecall

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

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍕 PG Vault - Server: $serverid           reference: pgvault.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵  PG Disk Used Space: $used of $capacity | $percentage Used Capacity

[1] Data Restore
[2] Data Backup
[3] Change Current ID: $serverid
[4] Change Restore ID: $restoreid
[5] Change Backup Location: $space
[6] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then vaultbackup; fi
elif [ "$typed" == "2" ]; then vaultrestore; fi
elif [ "$typed" == "3" ]; then
  # Why Here? Located Here for When User Installs PG
  echo "0" > /var/plexguide/server.id.stored
  bash /opt/plexguide/install/serverid.sh
elif [ "$typed" == "4" ]; then
  bash /opt/plexguide/menu/data/restoreid.sh
elif [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/data/location.sh
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
  exit
else
  bash /opt/plexguide/menu/pgvault/pgvault.sh
  exit
fi

bash /opt/plexguide/menu/pgvault/pgvault.sh
exit
