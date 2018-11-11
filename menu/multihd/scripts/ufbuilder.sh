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

#file="/var/plexguide/multi.count"
#  if [ -e "$file" ]; then
#    echo "" 1>/dev/null 2>&1
#  else
#    echo "1" > /var/plexguide/multi.count
#  fi

#count=$(cat /var/plexguide/multi.count)
#let "count++"
#echo $count

### Blank Out File
rm -rf /var/plexguide/multi.build 1>/dev/null 2>&1
rm -rf /var/plexguide/multi.unionfs 1>/dev/null 2>&1
rm -rf /var/plexguide/multi.read 1>/dev/null 2>&1
touch /var/plexguide/multi.build 1>/dev/null 2>&1

### Ensure Directory Exists
mkdir -p /opt/appdata/plexguide/multi 1>/dev/null 2>&1

### Count Inital List of Files
ls -la /opt/appdata/plexguide/multi | awk '{ print $9}' | tail -n +4 > /var/plexguide/multi.list

while read p; do
tmp=$(cat /opt/appdata/plexguide/multi/$p)
echo -n "$tmp:" >> /var/plexguide/multi.unionfs
echo "$p. $tmp" >> /var/plexguide/multi.read
done </var/plexguide/multi.list

builder=$(cat /var/plexguide/multi.unionfs)

number=1
break=0
  until [ "$break" == "1" ]; do
    check=$(grep -w "$number" /var/plexguide/multi.list)
    if [ "$check" == "$number" ]; then
        break=0
        let "number++"
        echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      else
        break=1
    fi
  done
echo $number > /var/plexguide/multi.filler

echo "INFO - PGBlitz: UnionFS Builder Added the Following: $builder " > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
