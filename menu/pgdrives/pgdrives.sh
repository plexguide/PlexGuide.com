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

# Declare Ports State
gdrive=$(cat /var/plexguide/rclone.gdrive)
tdrive=$(cat /var/plexguide/rclone.tdrive)

cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'tdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.tdrive
cat /root/.config/rclone/rclone.conf 2>/dev/null | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone.gdrive

  if [ "$gdrive" != "" ] && [ "$tdrive" == "" ]; then
  configure="GDrive"
  message="Deploy PG Drives: GDrive"
elif [ "$gdrive" != "" ] && [ "$tdrive" != "" ]; then
  configure="GDrive /w TDrive"
  message="Deploy PG Drives: GDrive /w TDrive"
else
  configure="Not Configured"
  message="Unable to Deploy: RClone is Unconfigured"
  fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to PG Drives
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: The PG Drives option is for READ ONLY SERVERS! Deploying this
edition; there is no movement of files. You can configure gdrive and/or
tdrive. This is great for a PLEX only server & etc. Making changes?
Make sure to redeploy the PG Drives!

1 - Configure RClone: $configure
2 - $message
3 - Exit

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
    if [ "$configure" == "GDrive" ]; then
    echo '/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-pgdrives --skip-tags encrypted
    elif [ "$configure" == "GDrive /w TDrive" ]; then
    echo '/mnt/tdrive=RO:/mnt/gdrive=RO:' > /var/plexguide/unionfs.pgpath
    ansible-playbook /opt/plexguide/roles/menu-move/remove-service.yml
    ansible-playbook /opt/plexguide/pg.yml --tags menu-pgdrives --skip-tags encrypted
    else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! WARNING! WARNING!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You Need to Configure: gdrive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 4
  fi
elif [ "$typed" == "3" ]; then
  exit
else
  bash /opt/plexguide/menu/pgdrives/pgdrives.sh
  exit
fi

bash /opt/plexguide/menu/pgdrives/pgdrives.sh
exit
