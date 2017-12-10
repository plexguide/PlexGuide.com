#!/bin/bash

clear

## Supporting Folders
mkdir -p /home/plexguide/move
mkdir -p /home/plexguide/gdrive
mkdir -p /home/plexguide/unionfs/tv
mkdir -p /home/plexguide/unionfs/movies
mkdir -p /opt/appdata/plexguide
mkdir -p /home/plexguide/plexdrive4

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

############################################# RCLONE
## Executes RClone Config
rclone config

# allows others to access fuse
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF

## Copying to /home/plexguide incase
cp ~/.config/rclone/rclone.conf /home/plexguide/.config/rclone

## Assigning Permissions to PlexGuide
chown -R plexguide:1000 /home/plexguide/.config/rclone/rclone.conf
chown -R plexguide:1000 /home/plexguide/gdrive
chown -R plexguide:1000 /home/plexguide/move
chown -R plexguide:1000 /home/plexguide/unionfs
chown -R plexguide:1000 /home/plexguide/plexdrive4

## RClone Script
tee "/opt/appdata/plexguide/rclone.sh" > /dev/null <<EOF
#!/bin/bash
rclone --allow-non-empty --allow-other mount gdrive: /home/plexguide/gdrive --bwlimit 8650k --size-only
EOF
chmod 755 /opt/appdata/plexguide/rclone.sh

## RClone Server
tee "/etc/systemd/system/rclone.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target
[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/bin/bash /opt/appdata/plexguide/rclone.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

######################################### UNIONFS
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


## Create the Move Script
tee "/opt/appdata/plexguide/move.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
while true
do
## Sync, Sleep 10 Minutes, Repeat. BWLIMIT Prevents Google 750GB Google Upload Ban
rclone move --bwlimit 9M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s /home/plexguide/move gdrive:/
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
User=plexguide
Group=1000
ExecStart=/bin/bash /opt/appdata/plexguide/move.sh
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
If you messed anything up, select [2] and run through again.  

bash /opt/plexguide/scripts/docker-no/continue.sh