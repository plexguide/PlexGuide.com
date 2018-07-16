#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
path=/opt/appdata/pgblitz/keys
rpath=/root/.config/rclone/rclone.conf

ls -la $path/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsa

#### Commenting Out To Let User See
while read p; do

tee "" >> /$rpath <<EOF
[$p]
type = drive
client_id =
client_secret =
scope = drive
root_folder_id =
service_account_file = /opt/appdata/pgblitz/keys/processed/$p
team_drive = 0BCGn24COUqr2Uk9PCB
EOF

done </tmp/pg.gdsa
