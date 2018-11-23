#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
image=$(cat /tmp/program_var)

image=netdata
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG - Multi Image Selector
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

count=1
while read p; do
  echo "$count - $p"
  echo "$p" > /tmp/display$count
  count=$[count+1]
done </opt/plexguide/containers/image/$image
echo ""
read -p '🚀 ZOOM ZOOM - Make Selection | PRESS [ENTER]: ' typed < /dev/tty
cat /tmp/display$typed
