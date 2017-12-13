#!/bin/bash

clear

## Supporting Folders
#mkdir -p /home/plexguide/move
mkdir -p /home/plexguide/.gcrypt
#mkdir -p /home/plexguide/gdrive
#mkdir -p /home/plexguide/unionfs/tv
#mkdir -p /home/plexguide/unionfs/movies
#mkdir -p /opt/appdata/plexguide
#mkdir -p /home/plexguide/plexdrive4
mkdir -p /home/plexguide/encrypt

## Installing rclone
  cd /tmp
  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  unzip rclone-current-linux-amd64.zip 1>/dev/null 2>&1
  cd rclone-*-linux-amd64
  cp rclone /usr/bin/ 1>/dev/null 2>&1
  chown plexguide:1000 /usr/bin/rclone 1>/dev/null 2>&1
  chmod 755 /usr/bin/rclone 1>/dev/null 2>&1
  mkdir -p /usr/local/share/man/ 1>/dev/null 2>&1
  cp rclone.1 /usr/local/share/man/man1/ 1>/dev/null 2>&1
  mandb 1>/dev/null 2>&1
  cd .. && sudo rm -r rclone* 1>/dev/null 2>&1
  cd ~

############################################# RCLONE
## Excutes the RClone Config
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

## Make RClone Directory incase
mkdir -p /home/plexguide/.config/rclone

## Copying to /home/plexguide incase
#cp ~/.config/rclone/rclone.conf /home/plexguide/.config/rclone/
echo hang 1
## Assigning Permissions to PlexGuide
chown -R plexguide:1000 /home/plexguide/.config/rclone
echo hang1b
chown -R plexguide:1000 /home/plexguide/encrypt  1>/dev/null 2>&1
chmod 777 -R plexguide:1000 /home/plexguide/encrypt  1>/dev/null 2>&1
echo hang1c
chown -R plexguide:1000 /home/plexguide/.gcrypt  1>/dev/null 2>&1
chmod 777 -R plexguide:1000 /home/plexguide/.gcrypt  1>/dev/null 2>&1
echo hang2
## RClone Script
tee "/opt/appdata/plexguide/rclone.sh" > /dev/null <<EOF
#!/bin/bash
rclone --allow-non-empty --allow-other mount gdrive: /home/plexguide/gdrive --bwlimit 8650k --size-only
EOF
chmod 755 /opt/appdata/plexguide/rclone.sh
echo hang3
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
echo hang4
## RClone Script
tee "/opt/appdata/plexguide/rclone-encrypt.sh" > /dev/null <<EOF
#!/bin/bash
rclone --allow-non-empty --allow-other mount gcrypt: /home/plexguide/.gcrypt --bwlimit 8650k --size-only
EOF
chmod 755 /opt/appdata/plexguide/rclone-encrypt.sh
echo hang5
## RClone Server
tee "/etc/systemd/system/rclone-encrypt.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target
[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/bin/bash /opt/appdata/plexguide/rclone-encrypt.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
####################################### Encrypted Service
echo hang6
## Create the RClone service for plexdrive4 encrypted mount point
tee "/etc/systemd/system/rclone-en.service" > /dev/null <<EOF
[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount crypt: /home/plexguide/encrypt --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
echo hang7
#### Create the RClone Service for a direct gdrive encrypted mount point
##tee "/etc/systemd/system/rclone-encrypt.service" > /dev/null <<EOF
##[Unit]
##Description=RClone Daemon
##After=multi-user.target

##[Service]
##Type=simple
##User=plexguide
##Group=1000
##ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount gcrypt: /home/plexguide/.gcrypt --bwlimit 8650k --size-only
##TimeoutStopSec=20
##KillMode=process
##RemainAfterExit=yes

##[Install]
##WantedBy=multi-user.target
##EOF

## Create the UnionFS Service for the plexdrive encrypted mount point
tee "/etc/systemd/system/unionfs-encrypt.service" > /dev/null <<EOF
[Unit]
Description=UnionFS Daemon
After=multi-user.target
[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/usr/bin/unionfs -o cow,allow_other,nonempty /home/plexguide/move=RW:/home/plexguide/encrypt=RO /home/plexguide/unionfs
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
echo hang8
## Create the Encrypted Move Script
tee "/opt/appdata/plexguide/move-en.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
while true
do
rclone move --bwlimit 9M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s /home/plexguide/move gcrypt:/
sleep 900
done
EOF
chmod 755 /opt/appdata/plexguide/move-en.sh
echo hang9
## Create the Encrypted Move Service
tee "/etc/systemd/system/move-en.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=plexguide
Group=1000
ExecStart=/bin/bash /opt/appdata/plexguide/move-en.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF
echo hang10
###### Ensure Changes Are Reflected
sudo systemctl daemon-reload
echo hang11
#stop unencrypted services
systemctl stop rclone 1>/dev/null 2>&1
systemctl stop move 1>/dev/null 2>&1
systemctl stop unionfs 1>/dev/null 2>&1
systemctl disable rclone 1>/dev/null 2>&1
systemctl disable move 1>/dev/null 2>&1
systemctl disable unionfs 1>/dev/null 2>&1
echo hang12
# ensure that the unencrypted services are on
systemctl enable rclone 1>/dev/null 2>&1
systemctl enable rclone-en 1>/dev/null 2>&1
systemctl enable move-en 1>/dev/null 2>&1
systemctl enable unionfs-encrypt 1>/dev/null 2>&1
systemctl enable rclone-encrypt 1>/dev/null 2>&1
systemctl start unionfs-encrypt 1>/dev/null 2>&1
systemctl start rclone 1>/dev/null 2>&1
systemctl start rclone-en 1>/dev/null 2>&1
systemctl start rclone-encrypt 1>/dev/null 2>&1
systemctl start move-en 1>/dev/null 2>&1
echo hang13

systemctl restart rclone 1>/dev/null 2>&1
systemctl restart rclone-encrypt 1>/dev/null 2>&1
systemctl restart rclone-en 1>/dev/null 2>&1
echo hang14
# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/rclone 1>/dev/null 2>&1
touch /var/plexguide/rclone/en 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/un 1>/dev/null 2>&1
echo hang15
# pauses
bash /opt/plexguide/scripts/docker-no/continue.sh
echo hang16
# sets a message
clear
cat << EOF
NOTE: You installed the encrypted version for the RClone data transport!
If you messed anything up, select [2] and run through again.
EOF

bash /opt/plexguide/scripts/docker-no/continue.sh
