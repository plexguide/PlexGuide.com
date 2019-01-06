#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
echo "plexguide.com" > /var/plexguide/server.domain
echo "1.1.1.1" > /var/plexguide/server.ip
echo "" > /var/plexguide/server.ports
echo "/mnt" > /var/plexguide/server.hd.path
echo "/mnt/downloads" > /var/plexguide/server.completed.path
echo "" > /var/plexguide/server.processing.path
echo "" > /var/plexguide/server.ht
echo "portainer" > /var/plexguide/tld.program
echo "1" > /var/plexguide/pg.ansible.stored
echo "2" > /var/plexguide/pg.ansible

# Force Common Things To Execute Such as Folders
echo "149" > /var/plexguide/pg.preinstall
# Changing Number Results in Forcing Portions of PreInstaller to Execute
echo "90" > /var/plexguide/pg.python
echo "6" > /var/plexguide/pg.folders
echo "13" > /var/plexguide/pg.rclone
echo "10" > /var/plexguide/pg.docker
echo "12" > /var/plexguide/server.id
echo "23" > /var/plexguide/pg.dependency
echo "10" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.motd
echo "85" > /var/plexguide/pg.alias
echo "2" > /var/plexguide/pg.dep
echo "1" > /var/plexguide/pg.cleaner
echo "3" > /var/plexguide/pg.gcloud
echo "12" > /var/plexguide/pg.hetzner
echo "1" > /var/plexguide/pg.amazonaws
