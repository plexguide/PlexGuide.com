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
#### Recall Download Point
mnt=$(cat /var/plexguide/server.hd.path)

#### Build up list backup list for the main.yml execution
while read p; do
  echo -n $p >> $mnt/pgops/backup.build
  echo -n " " >> $mnt/pgops/backup.build
done <$mnt/pgops/backup.list
