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
# Recalls Important Variables
#mnt=$(cat /var/plexguide/server.hd.path)
restoreid=$(cat /var/plexguide/restore.id)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  NOTE: Checking Server [$restoreid]'s backups
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Recalls List for Backup Operations
rclone ls gdrive:/plexguide/backup/$restoreid | awk '{ print $2 }' > /opt/appdata/plexguide/restore.list

### Builds Backup List - END
# Build up list backup list for the main.yml execution

#blank out restore.Build
echo "" > /opt/appdata/plexguide/restore.build

while read p; do
  p=${p%.tar}
  echo -n $p >> /opt/appdata/plexguide/restore.build
  echo -n " " >> /opt/appdata/plexguide/restore.build
done </opt/appdata/plexguide/restore.list

# Just for the Restore Interace for display


# Execute Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  LIST: Solo Restore >>> Via RClone - gdrive:/plexguide/backup/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

☑️  Restoring only one application. Certain apps that generated tons
of metadata can take quite a while (i.e. Plex, Sonarr, Radarr). Plex
alone can take 45min+. Type the exact name (case senstive)!

EOF
echo "✅️  Potential Apps to Restore: " && cat /opt/appdata/plexguide/restore.build

echo;
echo;
echo "⚠️  TO EXIT - type >>> exit"
echo;
read -p 'Type the App to Restore & Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - The Server ID Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  bash /opt/plexguide/menu/data/srestore/srestore.sh
  exit
elif [ "$typed" == "exit" ]; then
  exit
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  NOTE: Determing File Size - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

size=$(rclone ls gdrive:/plexguide/backup/ | grep sabnzbd | awk '{ print $1 }')
size=$(echo $(( 61000  / 1000 )))

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: Restoring - $typed | File Size: $size MB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Prevents From Repeating
sleep 4
fi
########################### Next Phase
echo $typed > /tmp/program_var
docker ps -a --format "{{.Names}}" | grep -c "\<$typed\>" >> /tmp/docker.check
ansible-playbook /opt/plexguide/menu/data/srestore/srestore.yml

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌇  PASS: Process Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
