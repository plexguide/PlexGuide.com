#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Deiteq & Admin9705
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
#mkdir -p /mnt/.gcrypt
#mkdir -p /mnt/encrypt

## Installing rclone
  cd /tmp
  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  unzip rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  cd rclone-*-linux-amd64
  cp rclone /usr/bin/ 1>/dev/null 2>&1
  chown 1000:1000 /usr/bin/rclone 1>/dev/null 2>&1
  chmod 775 /usr/bin/rclone 1>/dev/null 2>&1
  mkdir -p /usr/local/share/man/ 1>/dev/null 2>&1
  cp rclone.1 /usr/local/share/man/man1/ 1>/dev/null 2>&1
  mandb 1>/dev/null 2>&1
  cd .. && sudo rm -r rclone* 1>/dev/null 2>&1
  sudo rm -rf /var/plexguide/rclone-en.no
  sudo touch /var/plexguide/rclone-en.yes
  cd ~

############################################# RCLONE
## Excutes RClone Config
rclone config

## RClone - Replace Fuse by removing the # from user_allow_other
tee "/etc/fuse.conf" > /dev/null <<EOF
  # /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)

  # Set the maximum number of FUSE mounts allowed to non-root users.
  # The default is 1000.
  #mount_max = 1000

  # Allow non-root users to specify the allow_other or allow_root mount options.
  user_allow_other
EOF

mkdir -p /root/.config/rclone/ 1>/dev/null 2>&1

## Copying to /mnt incase
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
echo 1
fusermount -uz /mnt/gdrive
## RClone Script
tee "/opt/appdata/plexguide/gcrypt.sh" > /dev/null <<EOF
#!/bin/bash
rclone mount gcrypt: /mnt/gdrive \
	--buffer-size=16M \
	--dir-cache-time=672h \
	--umask 002 \
  --vfs-read-chunk-size=32M \
	--vfs-cache-max-age 675h \
	--vfs-read-chunk-size-limit=1G \
	--allow-non-empty \
	--allow-other \
  --size-only \
	--log-level INFO \
	--uid=1000 \
	--gid=1000 \
	--syslog \
  --config /root/.config/rclone/rclone.conf
EOF
chmod 775 /opt/appdata/plexguide/gcrypt.sh
echo 2
## RClone Server
tee "/etc/systemd/system/gcrypt.service" > /dev/null <<EOF
[Unit]
Description=GDrive Crypt Daemon
After=multi-user.target

[Service]
Type=simple
User=0
Group=0
ExecStart=/usr/bin/rclone mount gcrypt: /mnt/gdrive \
	--buffer-size=16M \
	--dir-cache-time=672h \
	--umask 002 \
  --vfs-read-chunk-size=32M \
	--vfs-cache-max-age 675h \
	--vfs-read-chunk-size-limit=1G \
	--allow-non-empty \
	--allow-other \
  --size-only \
	--log-level INFO \
	--uid=1000 \
	--gid=1000 \
	--syslog \
  --config /root/.config/rclone/rclone.conf

ExecStop=/bin/fusermount -uz /mnt/gdrive
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
echo 3
fusermount -uz /mnt/tdrive
## RClone Script
tee "/opt/appdata/plexguide/tcrypt.sh" > /dev/null <<EOF
#!/bin/bash
rclone mount tcrypt: /mnt/tdrive \
	--buffer-size=16M \
	--dir-cache-time=672h \
	--gid=1000 \
	--log-level INFO \
	--rc \
	--umask 002 \
	--vfs-cache-max-age 675h \
	--vfs-read-chunk-size-limit=1G \
	--allow-non-empty \
	--allow-other \
	--config /root/.config/rclone/rclone.conf \
	--size-only \
	--syslog \
	--uid=1000 \
	--vfs-read-chunk-size=32M
EOF
chmod 775 /opt/appdata/plexguide/tcyrpt.sh

## RClone Server
tee "/etc/systemd/system/tcrypt.service" > /dev/null <<EOF
[Unit]
Description=TDrive Crypt Daemon
After=multi-user.target

[Service]
Type=simple
User=0
Group=0
ExecStart=/usr/bin/rclone mount tcrypt: /mnt/tdrive \
	--buffer-size=16M \
	--dir-cache-time=672h \
	--gid=1000 \
	--log-level INFO \
	--rc \
	--umask 002 \
	--vfs-cache-max-age 675h \
	--vfs-read-chunk-size-limit=1G \
	--allow-non-empty \
	--allow-other \
	--config /root/.config/rclone/rclone.conf \
	--size-only \
	--syslog \
	--uid=1000 \
	--vfs-read-chunk-size=32M

ExecStop=/bin/fusermount -uz /mnt/tdrive
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
####################################### Encrypted Service
echo 4

echo 5
fusermount -uz /mnt/unionfs
## Create the UnionFS Service for the plexdrive encrypted mount point
tee "/etc/systemd/system/unionfs.service" > /dev/null <<EOF
[Unit]
Description=UnionFS Daemon
Requires=gcrypt.service
After=multi-user.target gcrypt.service
RequiresMountsFor=/mnt/gdrive

[Service]
Type=simple
User=0
Group=0
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /mnt/move=RW:/mnt/gdrive=RO:/mnt/tdrive=RO /mnt/unionfs
ExecStop=/bin/fusermount -uz /mnt/unionfs
TimeoutStopSec=20
#KillMode=process
KillMode=mixed
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF

echo 6
## Create the Encrypted Move Script
tee "/opt/appdata/plexguide/move.sh" > /dev/null <<EOF
#!/bin/bash

if pidof -o %PPID -x "$0"; then
   exit 1
fi

sleep 30
while true
do
## Sync, Sleep 5 Minutes, Repeat. BWLIMIT Prevents Google 750GB Google Upload Ban
rclone move --bwlimit 9M \
  --tpslimit 6 \
  --exclude='**partial~' \
  --exclude="**_HIDDEN~" \
  --exclude=".unionfs/**" \
  --exclude=".unionfs-fuse/**" \
  --checkers=16 \
  --max-size 99G \
  --log-file=/opt/appdata/plexguide/rclone \
  --log-level INFO \
  --stats 5s \
  /mnt/move gcrypt:/
sleep 300
# Remove empty directories (MrWednesday)
find "/mnt/move/" -mindepth 2 -type d -empty -delete
done
EOF
chmod 775 /opt/appdata/plexguide/move.sh

## Create the Encrypted Move Service
tee "/etc/systemd/system/move.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=0
Group=0
ExecStart=/bin/bash /opt/appdata/plexguide/move.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF
echo 7
###### Ensure Changes Are Reflected
sudo systemctl daemon-reload

#stop unencrypted services
systemctl stop rclone 1>/dev/null 2>&1
systemctl stop move 1>/dev/null 2>&1
#systemctl stop unionfs 1>/dev/null 2>&1
systemctl disable rclone 1>/dev/null 2>&1
systemctl disable move 1>/dev/null 2>&1
#systemctl disable unionfs 1>/dev/null 2>&1
echo 8
# ensure that the unencrypted services are on
systemctl disable rclone 1>/dev/null 2>&1
systemctl disable plexdrive 1>/dev/null 2>&1
systemctl disable rclone-en 1>/dev/null 2>&1
systemctl disable move-en 1>/dev/null 2>&1
systemctl disable unionfs-encrypt 1>/dev/null 2>&1
systemctl disable rclone-encrypt 1>/dev/null 2>&1
systemctl stop unionfs-encrypt 1>/dev/null 2>&1
systemctl stop rclone 1>/dev/null 2>&1
systemctl stop plexdrive 1>/dev/null 2>&1
systemctl stop rclone-en 1>/dev/null 2>&1
systemctl stop rclone-encrypt 1>/dev/null 2>&1
systemctl stop move-en 1>/dev/null 2>&1

sudo systemctl daemon-reload

echo 9
systemctl restart gcrypt 1>/dev/null 2>&1
systemctl restart unionfs 1>/dev/null 2>&1
systemctl restart move 1>/dev/null 2>&1

# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/pgdrive 1>/dev/null 2>&1
touch /var/plexguide/pgdrive/en 1>/dev/null 2>&1
rm -r /var/plexguide/pgdrive/un 1>/dev/null 2>&1
echo 10
# pauses
bash /opt/plexguide/scripts/docker-no/continue.sh
echo 11
# sets a message
clear
cat << EOF
NOTE: You installed the encrypted version for the RClone data transport!
If you messed anything up, select [2] and run through again.
EOF

bash /opt/plexguide/scripts/docker-no/continue.sh
