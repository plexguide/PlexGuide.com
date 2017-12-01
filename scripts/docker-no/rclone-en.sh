#!/bin/bash

## For Google Drive
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

rclone config

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


# disable the encrypted services to prevent a clash
systemctl disable rclone-en
systemctl disable move-en
systemctl stop rclone-en
#systemctl stop rclone-encrypt
systemctl stop move-en

# stop current services
systemctl stop unionfs
systemctl stop unionfs-encrypt
systemctl stop rclone
systemctl stop move

# ensure that the unencrypted services are on
systemctl enable rclone
systemctl enable move

# turn services back on
systemctl start unionfs
systemctl start rclone
systemctl start move

# disable the unencrypted services to prevent a clash
systemctl stop rclone
systemctl stop move
systemctl disable rclone
systemctl disable move

# stop current services
systemctl stop unionfs
systemctl stop unionfs-encrypt
systemctl stop rclone-en
systemctl stop rclone-encrypt
systemctl stop move-en

# copy rclone config from sudo user to root, which is the target
cp ~/.config/rclone/rclone.conf /root/.config/rclone/

# ensure that the encrypted services are on
systemctl enable rclone-en
systemctl enable rclone-encrypt
systemctl enable move-en

# turn services back on
systemctl start unionfs-encrypt
systemctl start rclone-en
systemctl start rclone-encrypt
systemctl start move-en

######################### REPEATS TO MAKE IT WORK
# disable the unencrypted services to prevent a clash
systemctl stop rclone
systemctl stop move
systemctl disable rclone
systemctl disable move

# stop current services
systemctl stop unionfs
systemctl stop unionfs-encrypt
systemctl stop rclone-en
systemctl stop rclone-encrypt
systemctl stop move-en

# copy rclone config from sudo user to root, which is the target
cp ~/.config/rclone/rclone.conf /root/.config/rclone/

# ensure that the encrypted services are on
systemctl enable rclone-en
systemctl enable rclone-encrypt
systemctl enable move-en

# turn services back on
systemctl start unionfs-encrypt
systemctl start rclone-en
systemctl start rclone-encrypt
systemctl start move-en

# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/rclone 1>/dev/null 2>&1
touch /var/plexguide/rclone/en 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/un

clear
cat << EOF
NOTE: You installed the encrypted version for the RClone data transport! If you
messed anything up, select [3] and run through again.  Also check:
http://enrclone.plexguide.com and or post on http://reddit.plexguide.com

HOW TO CHECK: In order to check if everything is working, have 1 item at least
in your google Drive

1. Type: /mnt/gdrive (and then you should see some item from your g-drive there)
2. Type: /mnt/unionfs (and you should see the same g-drive stuff there)

Verifying that 1 and 2 are important due to this is how your data will sync!

To make this easy, you can also use the checking tools built in!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh
