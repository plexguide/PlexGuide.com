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
echo "6.000J BETA" > /var/plexguide/pg.version
echo "99" > /var/plexguide/pg.preinstall

#### DOCKER START
echo "18.03.1" > /var/plexguide/pg.docker16
echo "18.03.1~ce-0~ubuntu" > /var/plexguide/pg.docker16.full
echo "stable" > /var/plexguide/pg.docker16.edition

echo "18.05.0" > /var/plexguide/pg.docker18
echo "18.05.0~ce~3-0~ubuntu" > /var/plexguide/pg.docker18.full
echo "edge" > /var/plexguide/pg.docker18.edition
#### DOCKER END

#### Installer
echo "2" > /var/plexguide/pg.ansible
echo "1" > /var/plexguide/pg.python
echo "1" > /var/plexguide/pg.docstart
echo "2" > /var/plexguide/pg.watchtower
echo "1" > /var/plexguide/pg.label
echo "8" > /var/plexguide/pg.alias
echo "1" > /var/plexguide/pg.dep ## dependencies