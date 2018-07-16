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
ls -la $path/unprocessed | awk '{ print $9}' | tail -n +4 > /tmp/pg.keys.temp
ls -la $path/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.keys.unprocessed.count

rm -r /tmp/pg.keys.processed.count
while read p; do
  p=${p:5}
  echo $p >> /tmp/pg.keys.processed.count
done </tmp/pg.keys.count

number=1
while read p; do
  mv $path/unprocessed/$p $path/processed/GDSA-$number
  let "number++"
done </tmp/pg.keys.temp
