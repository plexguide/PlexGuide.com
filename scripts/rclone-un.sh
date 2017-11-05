## Making the directories and setting the permissions
mkdir /mnt/rclone-union
mkdir /mnt/rclone-move
chmod 755 /mnt/rclone-move
chmod 755 /mnt/rclone-union

## Installing rclone
cd /tmp
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
cp rclone /usr/bin/
chown root:root /usr/bin/rclone
chmod 755 /usr/bin/rclone
mkdir -p /usr/local/share/man/man1
cp rclone.1 /usr/local/share/man/man1/
mandb
cd .. && sudo rm -r rclone*

## Making rclone directory
mkdir /mnt/rclone
chmod 755 /mnt/rclone
chown root /mnt/rclone

## Warning
clear
cat << EOF
Warning: You are going to make two rclone directories. Please visit
http://rclone.plexguide.com for a copy of the rclone instructions or
follow the quick instructions below.

Google Drive
[N] New Remote [9] Google, Enter Info, Verify, Ok, and then continue

Local Drive
[N] New Remote [11] Local, ignore the longfile name info,
type /mnt/rclone-move, OK, and then quit
EOF
echo
cd /opt/plexguide/scripts/
bash continue.sh

bash rclone-config.sh

## Copying the config from the local folder to the root folder

sudo mkdir /root/.config && sudo mkdir /root/.config/rclone 2>dev/null
sudo cp ~/.config/rclone/rclone.conf /root/.config/rclone 2>dev/null

## Replace Fuse by removing the # from user_allow_toerh
rm -r /etc/fuse.conf
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)

# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000

# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF

## Create the RClone Service
tee "/etc/systemd/system/rclone.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount gdrive: /mnt/rclone --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enable RClone Service
sudo systemctl daemon-reload
sudo systemctl enable rclone.service
sudo systemctl start rclone.service

## Create the UnionFS Service
tee "/etc/systemd/system/unionfs.service" > /dev/null <<EOF
[Unit]
Description=UnionFS Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /mnt/rclone-move=RW:/mnt/plexdrive4=RO /mnt/rclone-union
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enable RClone Service
sudo systemctl daemon-reload
sudo systemctl enable unionfs.service
sudo systemctl start unionfs.service

## Create the Move Script
tee "/opt/rclone-move.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
while true
do
# Purpose of sleep starting is so rclone has time to startup and kick in (1HR, you can change)
sleep 3600
# Anything above 9M will result in a google ban if uploading above 9M for 24 hours
rclone move --bwlimit 9M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s local:/mnt/rclone-move gdrive:/
done
EOF
chmod 755 /opt/rclone-move.sh

## Create the Move Service
tee "/etc/systemd/system/move.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/rclone-move.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable move.service
sudo systemctl start move.service
