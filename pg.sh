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

######################################################## START: Key Variables
rm -r /opt/plexguide/menu/interface/version/version.sh
sudo mkdir -p /opt/plexguide/menu/interface/version/
sudo wget --force-directories -O /opt/plexguide/menu/interface/version/version.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Edge/menu/interface/version/version.sh &>/dev/null &

# Check to See if The User Agrees
file="/var/plexguide/pg.agreement"
if [ ! -e "$file" ]; then
  python3 /opt/plexguide/menu/interface/install/scripts/yesno.py
fi

file="/var/plexguide/pg.agreement"
if [ ! -e "$file" ]; then
  echo ""
  bash /opt/plexguide/roles/ending/ending.sh
  echo "User Failed to Accept the Agreement."
  echo "Type -- bash install.sh -- to start again"
  echo
  exit
fi

# Ensure Server Path Exists
mkdir -p /var/plexguide
file="/var/plexguide/server.hd.path"
if [ ! -e "$file" ]; then
      echo "/mnt" > /var/plexguide/server.hd.path
fi

# Ahead to Get Python Installed First
#echo "11" > /var/plexguide/pg.python

# Generate Default YML
bash /opt/plexguide/menu/interface/install/scripts/yml-gen.sh
# Ensure Default Folder Is Created
mkdir -p /var/plexguide

# Ensure Variables Line Up With Installer If Changed
echo "11" > /var/plexguide/pg.python
echo "10" > /var/plexguide/pg.ansible

# Force Common Things To Execute Such as Folders
echo "148" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "12" > /var/plexguide/pg.rclone
echo "10" > /var/plexguide/pg.docker
echo "10" > /var/plexguide/pg.id
echo "20" > /var/plexguide/pg.dependency
echo "10" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.motd
echo "65" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep
echo "1" > /var/plexguide/pg.cleaner
echo "3" > /var/plexguide/pg.gcloud
# Declare Variables Vital for Operations
bash /opt/plexguide/menu/interface/install/scripts/declare.sh

######################################################## END: Key Variables
#
#
######################################################## START: Start
bash /opt/plexguide/menu/interface/install/scripts/start.sh
### Users Agreement Handling
file="/var/plexguide/update.failed"
if [ -e "$file" ]; then
  exit
fi

######################################################## END: Start
#
#
######################################################## START: Ansible
bash /opt/plexguide/menu/interface/install/scripts/ansible.sh ### Good
######################################################## END: Ansible
#
#
######################################################## START: New Install
file="/var/plexguide/ask.yes"
if [ -e "$file" ]; then
  file2="/var/plexguide/pg.number"
  if [ -e "$file2" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "Upgrade" > /var/plexguide/pg.number
  fi

  else
  echo off > /tmp/program_source
  bash /opt/plexguide/menu/interface/version/file.sh
  clear
  touch /var/plexguide/new.install
  bash /opt/plexguide/roles/ending/ending.sh
  echo "Type 'plexguide' again to complete the process!"
  echo
  exit
fi
######################################################## END: New Install

bash /opt/plexguide/install/alias.sh

### No Menu
python3 /opt/plexguide/menu/interface/install/scripts/motd.py

### Group Together
python3 /opt/plexguide/menu/interface/install/scripts/id.py
python3 /opt/plexguide/menu/interface/install/scripts/id2.py

python3 /opt/plexguide/menu/interface/install/scripts/dependency.py
python3 /opt/plexguide/menu/interface/install/scripts/folders.py
bash /opt/plexguide/menu/interface/install/scripts/docker.sh
bash /opt/plexguide/menu/interface/install/scripts/docstart.sh ### Good

echo "portainer" > /tmp/program_selection && ansible-playbook /opt/plexguide/programs/core/main.yml --extra-vars "quescheck=off cron=off display=off" &>/dev/null &

bash /opt/plexguide/menu/interface/install/scripts/watchtower.sh
python3 /opt/plexguide/menu/interface/install/scripts/motd.py
bash /opt/plexguide/menu/interface/install/scripts/cleaner.sh
python3 /opt/plexguide/menu/interface/install/scripts/gcloud.py
bash /opt/plexguide/menu/interface/install/scripts/python.sh
bash /opt/plexguide/menu/interface/install/scripts/reboot.sh
bash /opt/plexguide/menu/interface/install/scripts/edition.sh
python3 /opt/plexguide/menu/interface/install/scripts/rclone.py

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
