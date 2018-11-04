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

# Recalls List for Backup Operations
ls -la /opt/appdata | awk '{ print $9}' | tail -n +4 > /opt/appdata/plexguide/backup.list

#blank out restore.Build
touch /opt/appdata/plexguide/backup.build
rm -rf /opt/appdata/plexguide/backup.build

# Remove Items fromt the List

### Builds Backup List - END
sed -i -e "/traefik/d" /opt/appdata/plexguide/backup.list
sed -i -e "/watchtower/d" /opt/appdata/plexguide/backup.list
sed -i -e "/word*/d" /opt/appdata/plexguide/backup.list
sed -i -e "/x2go*/d" /opt/appdata/plexguide/backup.list
sed -i -e "/speed*/d" /opt/appdata/plexguide/backup.list
sed -i -e "/netdata/d" /opt/appdata/plexguide/backup.list
sed -i -e "/pgtrak/d" /opt/appdata/plexguide/backup.list
sed -i -e "/plexguide/d" /opt/appdata/plexguide/backup.list
sed -i -e "/pgdupes/d" /opt/appdata/plexguide/backup.list
sed -i -e "/portainer/d" /opt/appdata/plexguide/backup.list
sed -i -e "/cloudplow/d" /opt/appdata/plexguide/backup.list
sed -i -e "/phlex/d" /opt/appdata/plexguide/backup.list
sed -i -e "/pgblitz/d" /opt/appdata/plexguide/backup.list
sed -i -e "/cloudblitz/d" /opt/appdata/plexguide/backup.list
### Builds Backup List - END

# Build up list backup list for the main.yml execution

while read p; do
  echo -n $p >> /opt/appdata/plexguide/backup.build
  echo -n " " >> /opt/appdata/plexguide/backup.build
done </opt/appdata/plexguide/backup.list

# Execute Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  LIST: Solo Backup >>> Active Folders - /opt/appdata/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

☑️  Backing up only one application. Certain apps that generate tons
of metadata can take quite a while (i.e. Plex, Sonarr, Radarr). Plex
alone can take 45min+. Type the exact name (case senstive)!

EOF
echo "✅️  Potential Apps to Backup: "
cat /opt/appdata/plexguide/backup.build

echo;
echo;
echo "⚠️  TO EXIT - type >>> exit"
echo;
read -p 'Type the App to Backup & Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - The Server ID Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 3
  bash /opt/plexguide/menu/data/sbackup/sbackup.sh
  exit
elif [ "$typed" == "exit" ]; then
  exit
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: Backing Up $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

fi

########################### Next Phase
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  NOTE: Determing File Size - $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

size=$(ls -la /opt/appdata | grep "\<$typed\>" | awk '{ print $5 }' )

display=$(expr $size / 1000000 )

  if [ "$display" == "0" ]; then
    display=1
  fi

echo $display > /var/plexguide/rclone.size

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  NOTICE: Backing Up - $typed | File Size: $display MB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 2
echo $typed > /tmp/program_var
docker ps -a --format "{{.Names}}" | grep -c "\<$typed\>" > /tmp/docker.check
ansible-playbook /opt/plexguide/menu/data/sbackup/sbackup.yml

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌇  PASS: Process Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -n 1 -s -r -p "Press [ANY] Key to Continue "
echo ""
