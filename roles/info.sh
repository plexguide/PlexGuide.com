#!/bin/bash
#
# [PlexGuide Menu]
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
#### PG VARIBLES
echo "6.017 Edge" > /var/plexguide/pg.version
echo "127" > /var/plexguide/pg.preinstall

#### Installer
echo "5" > /var/plexguide/pg.ansible
echo "2" > /var/plexguide/pg.rclone
echo "1" > /var/plexguide/pg.python
echo "1" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.label
echo "26" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep ## dependencies
