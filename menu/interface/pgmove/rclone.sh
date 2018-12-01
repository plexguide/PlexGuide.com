#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
rclone config
mkdir -p /root/.config/rclone/
chown -R 1000:1000 /root/.config/rclone/
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
python3 /opt/plexguide/menu/interface/pgmove/pgmove.py
