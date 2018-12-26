#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

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
      else
        break=1
    fi
  done
echo $number > /var/plexguide/multi.filler
