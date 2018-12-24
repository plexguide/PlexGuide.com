#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
starter

######################################################## START: Key Variables
# ENSURE SERVER PATH EXISTS
mkdir -p ${abc}
file="${abc}/server.hd.path"
if [ ! -e "$file" ]; then echo "/mnt" > ${abc}/server.hd.path; fi

# Generate Default YML
# bash /opt/plexguide/install/yml-gen.sh

# Declare Variables Vital for Operations
bash /opt/plexguide/install/declare.sh

rm -rf /var/plexguide/pg.exit 1>/dev/null 2>&1
######################################################## START: New Install
file="${abc}/new.install"
if [ ! -e "$file" ]; then
  touch ${abc}/pg.number && echo off > /tmp/program_source
  bash /opt/plexguide/menu/interface/version/file.sh && touch ${abc}/new.install
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
exit; fi
# END: NEW INSTALL ############################################################

### No Menu
bash /opt/plexguide/install/motd.sh &>/dev/null &

# Ensure Docker is Turned On!
dstatus=$(docker ps --format '{{.Names}}' | grep "portainer")
if [ "$dstatus" != "portainer" ]; then
ansible-playbook /opt/plexguide/containers/portainer.yml &>/dev/null &
fi

mkdir -p /opt/mycontainers
yes | cp -rf /opt/mycontainers/* /opt/plexguide/containers
file="/opt/mycontainers/_template.yml"
if [ ! -e "$file" ]; then
yes | cp -rf /opt/plexguide/containers/_template.yml /opt/mycontainers
fi

bash /opt/plexguide/install/reboot.sh
# END: COMMON FUNCTIONS ########################################################
