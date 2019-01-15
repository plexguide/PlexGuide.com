#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

initial () {
  rolename='pgpress'
  mkdir -p "/opt/$rolename"
  ansible-playbook "/opt/plexguide/menu/$rolename/$rolename.yml"

  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/opt/pgpress/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
}

mainbanner () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Press                            📓 Reference: pgpress.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 PG Press is a combined group of services that enables the user to
deploy their own wordpress websites; including the use of other multiple
instances!

[1] Utilize PlexGuide's - PG Press
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        initial ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

# FUNCTIONS END ##############################################################
echo "" > /tmp/output.info
mainbanner
