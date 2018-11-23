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
  echo -n "$count - $p"
  echo -n "$p" > /tmp/display$count
  num=$[num+1]
done </opt/plexguide/containers/image/$image

read -p '🚀 Make Selection | PRESS [ENTER]: ' typed < /dev/tty
echo /tmp/display$typed
