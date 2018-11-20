#!/bin/bash
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
pgrole=$(cat /tmp/program_var)
path=$(cat /var/plexguide/server.hd.path)
tarlocation=$(cat /var/plexguide/data.location)
server_id=$(cat /var/plexguide/pg.serverid)

tar \
--ignore-failed-read \
--warning=no-file-changed \
--warning=no-file-removed \
-cvzf $tarlocation/$pgrole.tar /opt/appdata/$pgrole/

chown -R 1000:1000 $tarlocation
rclone copy $tarlocation/$pgrole.tar gdrive:/plexguide/backup/$server_id \
-v --checksum --drive-chunk-size=64M

du -sh --apparent-size /opt/appdata/$pgrole | awk '{print $1}'
rm -r $tarlocation/$pgrole.tar
