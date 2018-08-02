#!/bin/bash
#
# [Ansible Role]
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
tempbuild=$(cat /var/plexguide/json.tempbuild)
path=/opt/appdata/pgblitz/keys
rpath=/root/.config/rclone/rclone.conf
tdrive=$( cat /root/.config/rclone/rclone.conf | grep team_drive | head -n1 )
tdrive="${tdrive:13}"

#ls -la $path/processed | awk '{print $9}' | tail -n +4 > /tmp/pg.gdsa

#### Ensure to Backup TDrive & GDrive and Wipe the Rest
#while read p; do

####tempbuild is need in order to call the correct gdsa
mkdir -p $downloadpath/pgblitz/$tempbuild
tee >> /$rpath <<EOF
[$tempbuild]
type = drive
client_id =
client_secret =
scope = drive
root_folder_id =
service_account_file = /opt/appdata/pgblitz/keys/processed/$tempbuild
team_drive = $tdrive
EOF

#done </tmp/pg.gdsa
