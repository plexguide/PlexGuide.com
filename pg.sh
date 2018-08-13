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
# Generate Default YML
bash /opt/plexguide/roles/install/scripts/yml-gen.sh
# Ensure Default Folder Is Created
mkdir -p /var/plexguide
# PG Version
echo "6.031" > /var/plexguide/pg.version
# Force Common Things To Execute Such as Folders
echo "136" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "5" > /var/plexguide/pg.ansible
echo "2" > /var/plexguide/pg.rclone
echo "2" > /var/plexguide/pg.python
echo "1" > /var/plexguide/pg.docker
echo "1" > /var/plexguide/pg.id
echo "1" > /var/plexguide/pg.dependency
echo "1" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.motd
echo "31" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep
echo "1" > /var/plexguide/pg.cleaner

# Declare Variables Vital for Operations
bash /opt/plexguide/roles/install/scripts/declare.sh
######################################################## END: Key Variables
#
#
######################################################## START: Start
bash /opt/plexguide/roles/install/scripts/start.sh
### Users Agreement Handling
file="/var/plexguide/update.failed"
if [ -e "$file" ]; then
  exit
  #### Put Execute PG Command Here
fi
######################################################## END: Start
#
#
######################################################## START: Ansible
bash /opt/plexguide/roles/install/scripts/ansible.sh ### Good
######################################################## END: Ansible
#
#
######################################################## START: New Install
file="touch /var/plexguide/ask.yes"
if [ -e "$file" ]; then
  echo ""
  else
  bash /opt/plexguide/menus/version/main.sh
  bash /opt/plexguide/roles/ending/ending.sh
  touch /var/plexguide/pg.exit 1>/dev/null 2>&1
  exit
fi
######################################################## END: New Install
#
#
######################################################## START: Alias
bash /opt/plexguide/roles/install/scripts/alias.sh ### Good
######################################################## END: Alias
#
#
######################################################## START: Server ID
bash /opt/plexguide/roles/install/scripts/id.sh ### Good
######################################################## END: Server ID
#
#
######################################################## START: Folders
bash /opt/plexguide/roles/install/scripts/dependency.sh ### Good
######################################################## END: Folders
#
#
######################################################## START: Folders
bash /opt/plexguide/roles/install/scripts/folders.sh ### Good
######################################################## END: Folders
#
#
######################################################## START: Docker
bash /opt/plexguide/roles/install/scripts/docker.sh ### Test Docker
######################################################## END: Docker
#
#
######################################################## START: DocStart
bash /opt/plexguide/roles/install/scripts/docstart.sh ### Good
######################################################## END: DocStart
#
#
######################################################## START: Portainer
ansible-playbook /opt/plexguide/pg.yml --tags portainer &>/dev/null &
######################################################## END: Portainer
#
#
######################################################## START: WatchTower
bash /opt/plexguide/roles/install/scripts/watchtower.sh
######################################################## END: WatchTower
#
#
######################################################## START: MOTD
bash /opt/plexguide/roles/install/scripts/motd.sh
######################################################## END: MOTD
#
#
######################################################## START: RClone
bash /opt/plexguide/roles/install/scripts/rclone.sh
######################################################## END: RCone
#
#
######################################################## START: Cleaner
bash /opt/plexguide/roles/install/scripts/cleaner.sh
######################################################## END: Cleaner
#
#
######################################################## START: Python
bash /opt/plexguide/roles/install/scripts/python.sh &>/dev/null & ### Maybe Good?
######################################################## END: Python
#
#
######################################################## START: Reboot
bash /opt/plexguide/roles/install/scripts/reboot.sh
######################################################## END: Reboot
#
#
######################################################## START: Edition
bash /opt/plexguide/roles/install/scripts/edition.sh
######################################################## END: Edition
#
#
######################################################## START: Common Functions
# Ensure the PG Common Functions Are Aligned
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored
######################################################## END: Common Functions
