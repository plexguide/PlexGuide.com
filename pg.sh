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


pgedition () {
  file="${abc}/path.check"
  if [ ! -e "$file" ]; then touch ${abc}/path.check && bash /opt/plexguide/menu/dlpath/dlpath.sh; fi

  # FOR MULTI-HD EDITION
  file="${abc}/multi.unionfs"
    if [ ! -e "$file" ]; then touch ${abc}/multi.unionfs; fi
  # FOR PG-BLITZ
  file="${abc}/project.deployed"
    if [ ! -e "$file" ]; then echo "no" > ${abc}/project.deployed; fi
  file="${abc}/project.keycount"
    if [ ! -e "$file" ]; then echo "0" > ${abc}/project.keycount; fi
  file="${abc}/pg.serverid"
    if [ ! -e "$file" ]; then echo "[NOT-SET]" > ${abc}/pg.serverid; fi
}

ospgversion=$(cat /etc/*-release | grep Debian | grep 9)
if [ "$ospgversion" != "" ]; then echo "debian"> ${abc}/os.version;
else echo "ubuntu"> ${abc}/os.version; fi

echo "11" > ${abc}/pg.python
bash /opt/plexguide/install/python.sh
######################################################## START: Key Variables
rm -rf /opt/plexguide/menu/interface/version/version.sh
sudo mkdir -p /opt/plexguide/menu/interface/version/
sudo wget --force-directories -O /opt/plexguide/menu/interface/version/version.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Edge/menu/interface/version/version.sh &>/dev/null &

# ENSURE SERVER PATH EXISTS
mkdir -p ${abc}
file="${abc}/server.hd.path"
if [ ! -e "$file" ]; then echo "/mnt" > ${abc}/server.hd.path; fi

# Generate Default YML
bash /opt/plexguide/install/yml-gen.sh
# Ensure Default Folder Is Created

# Declare Variables Vital for Operations
bash /opt/plexguide/install/declare.sh
bash /opt/plexguide/install/aptupdate.sh

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

bash /opt/plexguide/install/alias.sh

### No Menu
bash /opt/plexguide/install/motd.sh &>/dev/null &

### Group Together
bash /opt/plexguide/install/serverid.sh
bash /opt/plexguide/install/dependency.sh
bash /opt/plexguide/install/folders.sh
bash /opt/plexguide/install/docker.sh
bash /opt/plexguide/install/docstart.sh

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

bash /opt/plexguide/install/motd.sh
bash /opt/plexguide/install/cleaner.sh
bash /opt/plexguide/install/gcloud.sh
bash /opt/plexguide/install/hetzner.sh

bash /opt/plexguide/install/reboot.sh
bash /opt/plexguide/install/rclone.sh
bash /opt/plexguide/menu/watchtower/watchtower.sh
# END: COMMON FUNCTIONS ########################################################

# ONE TIME PATH CHECK
pgedition
