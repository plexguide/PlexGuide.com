#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

defaultvars () {
  touch /var/plexguide/rclone.gdrive
  touch /var/plexguide/rclone.gcrypt
}

bwrecall () {
  variable /var/plexguide/move.bw "10"
  speed=$(cat /var/plexguide/move.bw)
}

bandwidth () {
  echo ""
  read -p 'TYPE a SERVER SPEED from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "1000" ]]; then echo "$typed" > /var/plexguide/move.bw && bwpassed;
  else badinput && bandwidth; fi
}

bwpassed () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASSED: Bandwidth Limit Set!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bwrecall && question1
}

question1 () {
bwrecall
readrcloneconfig

if [[ "$gdstatus" == "good" && "$gcstatus" == "bad" ]]; then message="3 - Deploy PG Drives : GDrive" && dstatus="1";
elif [[ "$gdstatus" == "good" && "$gcstatus" == "good" ]]; then message="3 - Deploy PG Drives : GDrive /w Encryption" && dstatus="2";
else message="" && dstatus="0"; fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Welcome to PG Move                     📓 Reference: move.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Basic Information

Utilizes Google Drive only and limitation is a 750GB daily upload limit.
10MB Throttle is the safe limit. Follow reference above for more info.

1 - Configure RClone
2 - Configure Throttle: $speed MB
$message
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p '🌍 Type Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo && readrcloneconfig && rcloneconfig && question1;
elif [ "$typed" == "2" ]; then bandwidth && question1;
elif [ "$typed" == "3" ]; then removemounts;
    if [ "$dstatus" == "1" ]; then
    echo "gdrive" > /var/plexguide/rclone/deploy.version
    ansible-playbook /opt/plexguide/menu/pgmove/gdrive.yml
    ansible-playbook /opt/plexguide/menu/pgmove/unionfs.yml
    ansible-playbook /opt/plexguide/menu/pgmove/move.yml
    question1
  elif [ "$dstatus" == "2" ]; then
    echo "gcrypt" > /var/plexguide/rclone/deploy.version
    ansible-playbook /opt/plexguide/menu/pgmove/gdrive.yml
    ansible-playbook /opt/plexguide/menu/pgmove/gcrypt.yml
    ansible-playbook /opt/plexguide/menu/pgmove/unionfs.yml
    ansible-playbook /opt/plexguide/menu/pgmove/move.yml
    question1
  else question1; fi
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then exit;
else
  badinput
  question1
fi
}

question1
