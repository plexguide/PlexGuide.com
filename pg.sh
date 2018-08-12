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
# Ensure Default Folder Is Created
mkdir -p /var/plexguide
# PG Version
echo "6.030 v2" > /var/plexguide/pg.version
# Changing Number Results in Forcing PreInstaller to Execute
echo "136" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "5" > /var/plexguide/pg.ansible
echo "2" > /var/plexguide/pg.rclone
echo "2" > /var/plexguide/pg.python
echo "1" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.label
echo "31" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep
######################################################## END: Key Variables
#
#
######################################################## START: Ansible
# Installs Ansible for New Users | Skips if Installed
bash /opt/plexguide/roles/install-new/scripts/ansible.sh
######################################################## END: Ansible
#
######################################################## START: Alias
# Installs PG Commands for New Users | Skips If Completed
bash /opt/plexguide/roles/install-new/scripts/alias.sh
######################################################## END: Alias
