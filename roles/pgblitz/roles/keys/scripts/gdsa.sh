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
ls -la $path/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsa
rpath=/root/.config/rclone/rclone.conf

#### Commenting Out To Let User See
while read p; do

tee "/opt/appdata/plexguide/move-en.sh" > /tmp/test.txt <<EOF
#!/bin/bash
sleep 30
while true
do
## Sync, Sleep 10 Minutes, Repeat. BWLIMIT Prevents Google 750GB Google Upload Ban
rclone move --bwlimit 10M --tpslimit 6 --exclude='**.partial~' --exclude="**_HIDDEN~" --exclude=".unionfs/**" --exclude=".unionfs-fuse/**" --checkers=16 --max-size 99G --log-level INFO --stats 5s /mnt/move gcrypt:/
sleep 480
# Remove empty directories (MrWednesday)
find "/mnt/move/" -mindepth 2 -type d -empty -delete
done
EOF

done </tmp/pg.gdsa

ansible-role backup
