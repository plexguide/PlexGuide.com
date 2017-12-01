#!/bin/bash

## Installing rclone
  cd /tmp
  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  unzip rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  cd rclone-*-linux-amd64
  cp rclone /usr/bin/ 1>/dev/null 2>&1
  chown root:root /usr/bin/rclone 1>/dev/null 2>&1
  chmod 755 /usr/bin/rclone 1>/dev/null 2>&1
  mkdir -p /usr/local/share/man/ 1>/dev/null 2>&1
  cp rclone.1 /usr/local/share/man/man1/ 1>/dev/null 2>&1
  mandb 1>/dev/null 2>&1
  cd .. && sudo rm -r rclone* 1>/dev/null 2>&1
  cd ~

## RClone - Replace Fuse by removing the # from user_allow_other
rm -r /etc/fuse.conf  1>/dev/null 2>&1
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
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount gdrive: /mnt/gdrive --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enable RClone Service
sudo systemctl daemon-reload

## Create the UnionFS Service
tee "/etc/systemd/system/unionfs.service" > /dev/null <<EOF
[Unit]
Description=UnionFS Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /mnt/move=RW:/mnt/plexdrive4=RO /mnt/unionfs
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enable UnionFS Service
sudo systemctl daemon-reload

## Create the Move Script
rm -r /opt/appdata/plexguide/move.sh 1>/dev/null 2>&1
tee "/opt/appdata/plexguide/move.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
while true
do
# Purpose of sleep starting is so rclone has time to startup and kick in (1HR, you can change)
# Anything above 9M will result in a google ban if uploading above 9M for 24 hours
rclone move --bwlimit 9M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s local:/mnt/move gdrive:/
sleep 600
done
EOF
chmod 755 /opt/appdata/plexguide/move.sh

## Create the Move Service
tee "/etc/systemd/system/move.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/appdata/plexguide/move.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

####################################### Encrypted Service
## Create the RClone Service for plexdrive4 mount point
tee "/etc/systemd/system/rclone-en.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount crypt: /mnt/encrypt --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enable RClone Service
sudo systemctl daemon-reload

## Create the RClone Service for a direct gdrive encrypted mount point
tee "/etc/systemd/system/rclone-encrypt.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount gcrypt: /mnt/.gcrypt --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enable RClone Service
sudo systemctl daemon-reload

## Create the UnionFS Service for the plexdrive encrypted mount point
tee "/etc/systemd/system/unionfs-encrypt.service" > /dev/null <<EOF
[Unit]
Description=UnionFS Daemon
After=multi-user.target
[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /mnt/move=RW:/mnt/encrypt=RO /mnt/unionfs
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

## Enable UnionFS Service
systemctl daemon-reload
systemctl enable unionfs-encrypt 1>/dev/null 2>&1
systemctl start unionfs-encrypt 1>/dev/null 2>&1

## Create the Encrypted Move Script
tee "/opt/appdata/plexguide/move-en.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
while true
do
rclone move --bwlimit 9M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s local:/mnt/move gcrypt:/
sleep 900
done
EOF
chmod 755 /opt/appdata/plexguide/move-en.sh

## Create the Encrypted Move Service
tee "/etc/systemd/system/move-en.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/appdata/plexguide/move-en.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

###################### If Running Unencrypted RClone, Turn This On

file="/var/plexguide/rclone/un"
if [ -e "$file" ]
then
    echo ""
    echo ">>> Running Encrypted RClone"
    echo ""
else
    systemctl enable unionfs
    systemctl enable rclone
    systemctl enable move
    systemctl start unionfs
    systemctl start rclone
    systemctl start move

    systemctl disable unionfs-encrypt
    systemctl disable rclone-en
    systemctl disable move-en
    systemctl stop unionfs-encrypt
    systemctl stop rclone-en
    systemctl stop move-en
fi

##################### If Running Encrypted RClone, Turn This On
file="/var/plexguide/rclone/en"
if [ -e "$file" ]
then
    echo ">>> Running Unencrypted RClone"
    echo ""
else
  systemctl disable unionfs 1>/dev/null 2>&1
  systemctl disable rclone 1>/dev/null 2>&1
  systemctl disable move 1>/dev/null 2>&1
  systemctl stop unionfs 1>/dev/null 2>&1
  systemctl stop rclone 1>/dev/null 2>&1
  systemctl stop move 1>/dev/null 2>&1

  systemctl enable unionfs-encrypt 1>/dev/null 2>&1
  systemctl enable rclone-en 1>/dev/null 2>&1
  systemctl enable move-en 1>/dev/null 2>&1
  systemctl start unionfs-encrypt 1>/dev/null 2>&1
  systemctl start rclone-en 1>/dev/null 2>&1
  systemctl start move-en 1>/dev/null 2>&1
fi
