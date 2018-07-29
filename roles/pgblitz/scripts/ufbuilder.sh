#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & FlickerRate
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
downloadpath=$(cat /var/plexguide/server.hd.path)
path=/opt/appdata/pgblitz/keys

ls -la $path/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsa.ufs
rm -r /tmp/pg.gdsa.build 1>/dev/null 2>&1

while read p; do
echo -n "$downloadpath/pgblitz/$p=RO:">> /tmp/pg.gdsa.build
done </tmp/pg.gdsa.ufs
builder=$( cat /tmp/pg.gdsa.build )
echo "INFO - PGBlitz: UnionFS Builder Added the Following: $builder " > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
