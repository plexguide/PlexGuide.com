#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
pgedition () {
  file="/var/plexguide/path.check"
  if [ ! -e "$file" ]; then touch /var/plexguide/path.check && bash /opt/plexguide/menu/dlpath/dlpath.sh; fi

  # FOR MULTI-HD EDITION
  file="/var/plexguide/multi.unionfs"
    if [ ! -e "$file" ]; then touch /var/plexguide/multi.unionfs; fi
  # FOR PG-BLITZ
  file="/var/plexguide/project.deployed"
    if [ ! -e "$file" ]; then echo "no" > /var/plexguide/project.deployed; fi
  file="/var/plexguide/project.keycount"
    if [ ! -e "$file" ]; then echo "0" > /var/plexguide/project.keycount; fi
  file="/var/plexguide/pg.serverid"
    if [ ! -e "$file" ]; then echo "[NOT-SET]" > /var/plexguide/pg.serverid; fi
}

ospgversion=$(cat /etc/*-release | grep Debian | grep 9)
if [ "$ospgversion" != "" ]; then echo "debian"> /var/plexguide/os.version;
else echo "ubuntu"> /var/plexguide/os.version; fi

echo "11" > /var/plexguide/pg.python
bash /opt/plexguide/install/python.sh
######################################################## START: Key Variables
rm -rf /opt/plexguide/menu/interface/version/version.sh
sudo mkdir -p /opt/plexguide/menu/interface/version/
sudo wget --force-directories -O /opt/plexguide/menu/interface/version/version.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Edge/menu/interface/version/version.sh &>/dev/null &

# ENSURE SERVER PATH EXISTS
mkdir -p /var/plexguide
file="/var/plexguide/server.hd.path"
if [ ! -e "$file" ]; then echo "/mnt" > /var/plexguide/server.hd.path; fi

# Generate Default YML
bash /opt/plexguide/install/yml-gen.sh
# Ensure Default Folder Is Created
mkdir -p /var/plexguide

# Force Common Things To Execute Such as Folders
echo "149" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "9" > /var/plexguide/pg.folders
echo "13" > /var/plexguide/pg.rclone
echo "10" > /var/plexguide/pg.docker
echo "12" > /var/plexguide/server.id
echo "23" > /var/plexguide/pg.dependency
echo "10" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.motd
echo "87" > /var/plexguide/pg.alias
echo "2" > /var/plexguide/pg.dep
echo "2" > /var/plexguide/pg.cleaner
echo "3" > /var/plexguide/pg.gcloud
echo "12" > /var/plexguide/pg.hetzner
echo "1" > /var/plexguide/pg.amazonaws
echo "7.3" > /var/plexguide/pg.verionid

# Declare Variables Vital for Operations
bash /opt/plexguide/install/declare.sh
bash /opt/plexguide/install/aptupdate.sh

######################################################## START: New Install
file="/var/plexguide/new.install"
if [ ! -e "$file" ]; then
  touch /var/plexguide/pg.number && echo off > /tmp/program_source
  bash /opt/plexguide/menu/interface/version/file.sh && touch /var/plexguide/new.install
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
