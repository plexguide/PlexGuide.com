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
ls -la /opt/appdata | awk '{ print $9}' | tail -n +4 > /tmp/backup.list

# Remove Items fromt the List

### Builds Backup List - END
sed -i -e "/traefik/d" /tmp/backup.list
sed -i -e "/watchtower/d" /tmp/backup.list
sed -i -e "/word*/d" /tmp/backup.list
sed -i -e "/x2go*/d" /tmp/backup.list
sed -i -e "/speed*/d" /tmp/backup.list
sed -i -e "/netdata/d" /tmp/backup.list
sed -i -e "/pgtrak/d" /tmp/backup.list
sed -i -e "/plexguide/d" /tmp/backup.list
sed -i -e "/pgdupes/d" /tmp/backup.list
sed -i -e "/portainer/d" /tmp/backup.list
sed -i -e "/cloudplow/d" /tmp/backup.list
sed -i -e "/phlex/d" /tmp/backup.list
sed -i -e "/pgblitz/d" /tmp/backup.list
sed -i -e "/cloudblitz/d" /tmp/backup.list
### Builds Backup List - END

# Build up list backup list for the main.yml execution

while read p; do
  echo -n $p >> /tmp/backup.build
  echo -n " " >> /tmp/backup.build
done </tmp/backup.list

# Execute Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  LIST: Solo Backup >>> Active Folders - /opt/appdata/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Backing up only one application. Certain apps that generate tons
of metadata can take quite a while (i.e. Plex, Sonarr, Radarr). Plex
alone can take 45min+. Type the exact name (case senstive)!

EOF

cat /tmp/backup.build

echo;
echo;
echo "TO EXIT - type >>> exit"
echo;
read -p 'Type the App to Backup & Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - The Server ID Cannot Be Blank!
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
✅️ PASS: ServerID Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Prevents From Repeating
sleep 3
fi

fi
