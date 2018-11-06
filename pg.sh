#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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

# Ahead to Get Python Installed First
touch /var/plexguide/pg.edition
bash /opt/plexguide/menu/interface/install/scripts/edition.sh

echo "11" > /var/plexguide/pg.python
bash /opt/plexguide/install/python.sh
######################################################## START: Key Variables
rm -rf /opt/plexguide/menu/interface/version/version.sh
sudo mkdir -p /opt/plexguide/menu/interface/version/
sudo wget --force-directories -O /opt/plexguide/menu/interface/version/version.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Edge/menu/interface/version/version.sh &>/dev/null &


# Ensure Server Path Exists
mkdir -p /var/plexguide
file="/var/plexguide/server.hd.path"
if [ ! -e "$file" ]; then
      echo "/mnt" > /var/plexguide/server.hd.path
fi



# Generate Default YML
bash /opt/plexguide/menu/interface/install/scripts/yml-gen.sh
# Ensure Default Folder Is Created
mkdir -p /var/plexguide

# Force Common Things To Execute Such as Folders
echo "149" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "5" > /var/plexguide/pg.folders
echo "13" > /var/plexguide/pg.rclone
echo "10" > /var/plexguide/pg.docker
echo "12" > /var/plexguide/server.id
echo "21" > /var/plexguide/pg.dependency
echo "10" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.motd
echo "66" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep
echo "1" > /var/plexguide/pg.cleaner
echo "3" > /var/plexguide/pg.gcloud

# Declare Variables Vital for Operations
bash /opt/plexguide/menu/interface/install/scripts/declare.sh
bash /opt/plexguide/install/aptupdate.sh

######################################################## START: New Install
file="/var/plexguide/new.install"
if [ ! -e "$file" ]; then
  echo "Upgrade" > /var/plexguide/pg.number
  else
  echo off > /tmp/program_source
  bash /opt/plexguide/menu/interface/version/file.sh
  clear
  touch /var/plexguide/new.install
  bash /opt/plexguide/roles/ending/ending.sh
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> plexguide
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  exit
  fi
fi
######################################################## END: New Install

bash /opt/plexguide/install/alias.sh

### No Menu
bash /opt/plexguide/install/motd.sh &>/dev/null &

### Group Together
bash /opt/plexguide/install/serverid.sh
bash /opt/plexguide/install/dependency.sh
bash /opt/plexguide/install/folders.sh
bash /opt/plexguide/menu/interface/install/scripts/docker.sh
bash /opt/plexguide/menu/interface/install/scripts/docstart.sh ### Good

echo "portainer" > /tmp/program_selection && ansible-playbook /opt/plexguide/programs/core/main.yml --extra-vars "quescheck=off cron=off display=off" &>/dev/null &

bash /opt/plexguide/menu/interface/install/scripts/watchtower.sh
bash /opt/plexguide/install/motd.sh
bash /opt/plexguide/menu/interface/install/scripts/cleaner.sh
bash /opt/plexguide/install/gcloud.sh

bash /opt/plexguide/menu/interface/install/scripts/reboot.sh
bash /opt/plexguide/install/rclone.sh

######################################################## END: Common Functions
#
#
################################ ONE TIME PATH CHECK
file="/var/plexguide/path.check"
if [ ! -e "$file" ]; then
  touch /var/plexguide/path.check
  bash /opt/plexguide/menu/interface/dlpath/main.sh
fi
#################### FILL IN Variables

### For MultiHD Edition
file="/var/plexguide/multi.unionfs"
  if [ ! -e "$file" ]; then
    touch /var/plexguide/multi.unionfs
  fi

### For PGBlitz - Ensure Not Deployed Start
  file="/var/plexguide/project.deployed"
    if [ ! -e "$file" ]; then
      echo "no" > /var/plexguide/project.deployed
    fi

  file="/var/plexguide/project.keycount"
    if [ ! -e "$file" ]; then
      echo "0" > /var/plexguide/project.keycount
    fi

  file="/var/plexguide/move.bw"
  if [ ! -e "$file" ]; then
    echo "10" > /var/plexguide/move.bw
  fi

  file="/var/plexguide/pg.serverid"
  if [ ! -e "$file" ]; then
    echo "[NOT-SET]" > /var/plexguide/pg.serverid
  fi
