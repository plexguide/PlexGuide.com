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

#build a service out of this
#Remake another for PGBlitz
#clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudst2 --skip-tags cron
#build unionfs additon build script

path=/opt/appdata/pgblitz/keys
rpath=/root/.config/rclone/rclone.conf

ls -la $path/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsa.ufs
echo "" > /tmp/pg.gdsa.build

while read p; do
echo -n "/mnt/pgblitz/$p=RO;">> /tmp/pg.gdsa.build
done </tmp/pg.gdsa.ufs
builder=$( cat /tmp/pg.gdsa.build )
echo "INFO - PGBlitz: UnionFS Builder Added the Following: $builder " > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
