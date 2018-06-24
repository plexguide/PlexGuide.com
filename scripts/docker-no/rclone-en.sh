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

## Supporting Folders
mkdir -p /mnt/.gcrypt
mkdir -p /mnt/encrypt
echo 1
## Installing RClone
  cd /tmp
  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  unzip rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  cd rclone-*-linux-amd64
  cp rclone /usr/bin/ 1>/dev/null 2>&1
  chown 1000:1000 /usr/bin/rclone 1>/dev/null 2>&1
  chmod 755 /usr/bin/rclone 1>/dev/null 2>&1
  mkdir -p /usr/local/share/man/ 1>/dev/null 2>&1
  cp rclone.1 /usr/local/share/man/man1/ 1>/dev/null 2>&1
  mandb 1>/dev/null 2>&1
  cd .. && sudo rm -r rclone* 1>/dev/null 2>&1
  cd ~
echo 2
############################################# RCLONE
## Executes RClone Config
rclone config
echo 3
# allows others to access fuse
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF
echo 4
mkdir -p /root/.config/rclone/ 1>/dev/null 2>&1
echo 5
## Copying to /mnt incase
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
chown -R 1000:1000 /root
chmod 775 /root/.config/rclone/rclone.conf
echo 6
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rclone_en
echo 7
## RClone Script
chmod 755 /opt/appdata/plexguide/rclone.sh
chmod 755 /opt/appdata/plexguide/rclone-en.sh
chmod 755 /opt/appdata/plexguide/rclone-encrypt.sh
echo 8
## Create the Move Script
chmod 755 /opt/appdata/plexguide/move-en.sh
echo 9
###### Ensure Changes Are Reflected
#sudo systemctl daemon-reload

#stop unencrypted services
systemctl disable rclone 1>/dev/null 2>&1
systemctl disable move 1>/dev/null 2>&1
systemctl disable unionfs 1>/dev/null 2>&1
systemctl stop unionfs 1>/dev/null 2>&1
systemctl stop rclone 1>/dev/null 2>&1
systemctl stop move 1>/dev/null 2>&1
echo 10
# ensure that the encrypted services are on
systemctl enable rclone 1>/dev/null 2>&1
systemctl enable rclone-en 1>/dev/null 2>&1
systemctl enable move-en 1>/dev/null 2>&1
systemctl enable unionfs-encrypt 1>/dev/null 2>&1
systemctl enable rclone-encrypt 1>/dev/null 2>&1
systemctl start rclone 1>/dev/null 2>&1
systemctl start rclone-en 1>/dev/null 2>&1
systemctl start move-en 1>/dev/null 2>&1
systemctl start unionfs-encrypt 1>/dev/null 2>&1
systemctl start rclone-encrypt 1>/dev/null 2>&1
echo 11
systemctl restart rclone 1>/dev/null 2>&1
systemctl restart rclone-en 1>/dev/null 2>&1
systemctl restart rclone-encrypt 1>/dev/null 2>&1
# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/rclone 1>/dev/null 2>&1
touch /var/plexguide/rclone/en 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/un 1>/dev/null 2>&1
echo 12
# pauses
bash /opt/plexguide/scripts/docker-no/continue.sh
