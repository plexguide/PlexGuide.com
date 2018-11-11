#!/bin/bash
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
touch /var/plexguide/rclone.tdrive

cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'tdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.tdrive
cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gdrive

# Declare Ports State
gdrive=$(cat /var/plexguide/rclone.gdrive)
tdrive=$(cat /var/plexguide/rclone.tdrive)

  if [ "$gdrive" != "" ] && [ "$tdrive" == "" ]; then
  configure="GDrive"
  message="Deploy PG Drives: GDrive"
elif [ "$gdrive" != "" ] && [ "$tdrive" != "" ]; then
  configure="GDrive /w tdrive"
  message="Deploy PG Drives : GDrive /w tdrive"
else
  configure="Not Configured"
  message="Unable to Deploy : RClone is Unconfigured"
  fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Welcome to PG Blitz
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Team Drives are used to surpass the 750 GB Daily Upload Limit.

1 - Configure RClone : $configure
2 - Key Management   : $keys Keys Exist
3 - E-Mail Share Gen
4 - Deploy PBlitz
5 - Exit

a - Download Path    : $path
b - Disable PG Blitz

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    rclone config
    mkdir -p /root/.config/rclone/
    chown -R 1000:1000 /root/.config/rclone/
    cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
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
  bash /opt/plexguide/menu/pgblitz/pgblitz.sh
  exit
  else
  echo "$typed" > /var/plexguide/move.bw
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASSED: Bandwidth Limit Set!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  fi
elif [ "$typed" == "3" ]; then
    if [ "$configure" == "GDrive" ]; then
    echo '/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move --skip-tags encrypted
    elif [ "$configure" == "GDrive /w tdrive" ]; then
    echo '/mnt/tdrive=RO:/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-move
    else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! WARNING! WARNING! You Need to Configure: gdrive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 4
  fi
elif [ "$typed" == "5" ]; then
  exit
elif [ "$typed" == "a" ]; then
  bash /opt/plexguide/menu/interface/dlpath/main.sh
elif [ "$typed" == "b" ]; then
  sudo systemctl stop pgblitz 1>/dev/null 2>&1
  sudo systemctl rm pgblitz 1>/dev/null 2>&1
else
  bash /opt/plexguide/menu/pgblitz/pgblitz.sh
  exit
fi

bash /opt/plexguide/menu/pgblitz/pgblitz.sh
exit
