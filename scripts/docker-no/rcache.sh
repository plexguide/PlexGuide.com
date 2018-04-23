#!/bin/bash
#
# [PlexGuide Menu]
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

clear

## Installing RClone
  curl https://rclone.org/install.sh | sudo bash -s beta 1>/dev/null 2>&1
  cd .. && sudo rm -r rclone* 1>/dev/null 2>&1

# allows others to access fuse
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF

## execute rclone
rclone config

mkdir -p /root/.config/rclone/ 1>/dev/null 2>&1

## Copying to /mnt incase
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rcache_un #--skip-tags=rclone_temp

## RClone Script
chmod 755 /opt/appdata/plexguide/rclone.sh

## Create the Move Script
chmod 755 /opt/appdata/plexguide/move.sh

###### Ensure Changes Are Reflected
#sudo systemctl daemon-reload

#stop encrypted services
systemctl stop rclone-en 1>/dev/null 2>&1
systemctl stop move-en 1>/dev/null 2>&1
systemctl stop unionfs-encrypt 1>/dev/null 2>&1
systemctl stop rclone-encrypt 1>/dev/null 2>&1
systemctl stop rclone 1>/dev/null 2>&1
systemctl disable rclone-en 1>/dev/null 2>&1
systemctl disable move-en 1>/dev/null 2>&1
systemctl disable unionfs-encrypt 1>/dev/null 2>&1
systemctl disable rclone-encrypt 1>/dev/null 2>&1
systemctl stop rclone 1>/dev/null 2>&1

systemctl enable rcache 1>/dev/null 2>&1
systemctl enable move 1>/dev/null 2>&1
systemctl enable unionfsc 1>/dev/null 2>&1
systemctl enable gdrive 1>/dev/null 2>&1
systemctl start unionfsc 1>/dev/null 2>&1
systemctl start gdrive 1>/dev/null 2>&1
systemctl start move 1>/dev/null 2>&1
systemctl start rcache 1>/dev/null 2>&1

#systemctl restart rclone 1>/dev/null 2>&1
# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/rclone 1>/dev/null 2>&1
touch /var/plexguide/rclone/un 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/en 1>/dev/null 2>&1

## testing
#ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags cloudplow

# pauses
bash /opt/plexguide/scripts/docker-no/continue.sh
