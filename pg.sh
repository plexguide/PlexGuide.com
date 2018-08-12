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
echo "1" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.label
echo "31" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep
######################################################## END: Key Variables
#
#
######################################################## START: Ansible
bash /opt/plexguide/roles/install/scripts/ansible.sh
######################################################## END: Ansible
#
#
######################################################## START: Alias
bash /opt/plexguide/roles/install/scripts/alias.sh
######################################################## END: Alias
#
#
######################################################## START: Alias
bash /opt/plexguide/roles/install/scripts/folders.sh
######################################################## END: Alias
#
#
######################################################## START: Docker
bash /opt/plexguide/roles/install/scripts/docker.sh
######################################################## END: Docker
#
#
######################################################## START: DocStart
bash /opt/plexguide/roles/install/scripts/docstart.sh
######################################################## END: DocStart
#
#
######################################################## START: Python
bash /opt/plexguide/roles/install/scripts/python.sh &>/dev/null &
######################################################## END: Python
#
#
######################################################## START: Common Functions
# Ensure the PG Common Functions Are Aligned
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored
######################################################## END: Common Functions
