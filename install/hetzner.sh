#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
touch /var/plexguide/pg.hetzner.stored
start=$( cat /var/plexguide/pg.hetzner )
stored=$( cat /var/plexguide/pg.hetzner.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  INSTALLING: Hetzner's HCloud
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Assist's in generating virtual machines for Hetzner Cloud Servers!

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
sleep 5

if [ -e "$file" ]; then rm -rf /bin/hcloud; fi

version="v1.10.0"
wget -P /opt/appdata/plexguide "https://github.com/hetznercloud/cli/releases/download/$version/hcloud-linux-amd64-$version.tar.gz"
tar -xvf "/opt/appdata/plexguide/hcloud-linux-amd64-$version.tar.gz" -C /opt/appdata/plexguide
mv "/opt/appdata/plexguide/hcloud-linux-amd64-$version/bin/hcloud" /bin/
rm -rf /opt/appdata/plexguide/hcloud-linux-amd64-$version.tar.gz
rm -rf /opt/appdata/plexguide/hcloud-linux-amd64-$version

# Prevents From Repeating
cat /var/plexguide/pg.hetzner > /var/plexguide/pg.hetzner.stored

fi
