#!/bin/bash

clear

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

## Supporting Folders
mkdir -p /home/plexguide/move
mkdir -p /home/plexguide/gdrive
mkdir -p /home/plexguide/unionfs
mkdir -p /opt/appdata/plexguide/scripts

## Executes RClone Config
sudo rclone config

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

####################################### RCLONE

## Create the RClone Script
tee "/opt/appdata/plexguide/scripts/rclone-un.sh" > /dev/null <<EOF
#!/bin/bash
rclone --allow-non-empty --allow-other mount gdrive: /home/plexguide/gdrive --bwlimit 8650k --size-only
EOF
chmod 755 /opt/appdata/plexguide/scripts/rclone-un.sh

## Create the RClone Service
tee "/etc/systemd/system/rclone-un.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=6000
Group=1000
ExecStart=/bin/bash /opt/appdata/plexguide/scripts/rclone-un.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

######################################## UNIONFS

## Create the UnionFS Service
tee "/etc/systemd/system/unionfs.service" > /dev/null <<EOF
[Unit]
Description=UnionFS Daemon
After=multi-user.target

[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /home/plexguide/move=RW:/home/plexguide/plexdrive4=RO /home/plexguide/unionfs
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

######################################## MOVE SERVICE

## Create the Move Script
rm -r /opt/appdata/plexguide/scripts/move.sh 1>/dev/null 2>&1
tee "/opt/appdata/plexguide/scripts/move.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
while true
do
# Script kicks in every 10 minutes (loop) and aynthing above 9M may result in a Google Upload Ban
rclone move --bwlimit 9M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s local:/home/plexguide/move gdrive:/
sleep 600
done
EOF
chmod 755 /opt/appdata/plexguide/scripts/move.sh

## Create the Move Service
tee "/etc/systemd/system/move.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/bin/bash /opt/appdata/plexguide/scripts/move.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

###### Ensure Changes Are Reflected
sudo systemctl daemon-reload

#stop encrypted services
systemctl disable rclone-en 1>/dev/null 2>&1
systemctl disable move-en 1>/dev/null 2>&1
systemctl disable unionfs-encrypt 1>/dev/null 2>&1
systemctl disable rclone-encrypt 1>/dev/null 2>&1
systemctl stop rclone-en 1>/dev/null 2>&1
systemctl stop move-en 1>/dev/null 2>&1
systemctl stop unionfs-encrypt 1>/dev/null 2>&1
systemctl stop rclone-encrypt 1>/dev/null 2>&1

# ensure that the unencrypted services are on
systemctl enable rclone 1>/dev/null 2>&1
systemctl enable move 1>/dev/null 2>&1
systemctl enable unionfs 1>/dev/null 2>&1
systemctl start unionfs 1>/dev/null 2>&1 
systemctl start rclone 1>/dev/null 2>&1
systemctl start move 1>/dev/null 2>&1

# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/rclone 1>/dev/null 2>&1
touch /var/plexguide/rclone/un 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/en 1>/dev/null 2>&1

# pauses
bash /opt/plexguide/scripts/docker-no/continue.sh

# sets a message
clear
cat << EOF
NOTE: You installed the unencrypted version for the RClone data transport!
If you messed anything up, select [2] and run through again.  Also check:
http://unrclone.plexguide.com and or post on http://reddit.plexguide.com

HOW TO CHECK: In order to check if everything is working, have 1 item at least
in your google Drive

1. Type: /mnt/gdrive (and then you should see some item from your g-drive there)
2. Type: /mnt/unionfs (and you should see the same g-drive stuff there)

Verifying that 1 and 2 are important due to this is how your data will sync!

To make it easy, you can also use the CHECKING TOOLS built in!

EOF

bash /opt/plexguide/scripts/docker-no/continue.sh
