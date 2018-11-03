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

# Touch Variables Incase They Do Not Exist
touch /var/plexguide/rclone.gdrive
touch /var/plexguide/rclone.gcrypt

file="/var/plexguide/move.bw"
  if [ -e "$file" ]; then
    speed=$(cat /var/plexguide/move.bw)
  else
    echo "10" > /var/plexguide/move.bw
  fi

cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gcrypt
cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gdrive

# Declare Ports State
gdrive=$(cat /var/plexguide/rclone.gdrive)
gcrypt=$(cat /var/plexguide/rclone.gcrypt)

  if [ "$gdrive" != "" ] && [ "$gcrypt" == "" ]; then
  configure="GDrive"
  message="Deploy PG Drives: GDrive"
elif [ "$gdrive" != "" ] && [ "$gcrypt" != "" ]; then
  configure="GDrive /w GCrypt"
  message="Deploy PG Drives: GDrive /w GCrypt"
else
  configure="Not Configured"
  message="Unable to Deploy: RClone is Unconfigured"
  fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to PG Move
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: PG Move utilizes only GDrive (no teamdrives)! PG Move will allow
you to move up to 750GB per day! If you need more, please switch to
teamdrive. You can configure and add gcrypt for encryptions (follow the
wiki). A 10MB speed is the safe limit if your going to upload
constantly for 24 hours!

1 - Configure RClone : $configure
2 - Configure BWLimit: $speed
3 - $message
4 - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    bash /opt/plexguide/menu/interface/pgdrives/rclone.sh
elif [ "$typed" == "2" ]; then

  # Standby
  read -p 'TYPE a SERVER SPEED from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty

    if [ $typed -gt 1000 -o $typed -lt 1 ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ⛔️ WARNING! Must be a Number between 1 - 1000 (Example: 20)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  bash /opt/plexguide/install/pgmove/pgmove.sh
  exit
  else
  echo "$typed" > /var/plexguide/bw.limit
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ PASSED: Bandwidth Limit Set!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  fi
elif [ "$typed" == "3" ]; then
    if [ "$configure" == "GDrive" ]; then
    echo '/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move --skip-tags encrypted
    elif [ "$configure" == "GDrive /w GCrypt" ]; then
    echo '/mnt/gcrypt=RO:/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move
    else
tee <<-EOF

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ⛔️ WARNING! WARNING! WARNING!                                       ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ You Need to Configure: gdrive                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
  sleep 4
  fi
elif [ "$typed" == "3" ]; then
  bash /opt/plexguide/roles/ending/ending.sh
  exit
else
  bash /opt/plexguide/menu/pgmove/pgmove.sh
  exit
fi

bash /opt/plexguide/menu/pgmove/pgmove.sh
exit
