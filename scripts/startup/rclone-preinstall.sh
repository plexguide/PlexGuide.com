#!/bin/bash

###################### If Running Unencrypted RClone, Turn This On

file="/var/plexguide/rclone/un"
if [ -e "$file" ]
then
    echo ">>> Running Unencrypted RClone"
    systemctl enable unionfs 1>/dev/null 2>&1
    systemctl enable rclone 1>/dev/null 2>&1
    systemctl enable move 1>/dev/null 2>&1
    systemctl start unionfs 1>/dev/null 2>&1
    systemctl start rclone 1>/dev/null 2>&1
    systemctl start move 1>/dev/null 2>&1

    systemctl disable unionfs-encrypt 1>/dev/null 2>&1
    systemctl disable rclone-en 1>/dev/null 2>&1
    systemctl disable rclone-encrypt 1>/dev/null 2>&1
    systemctl disable move-en 1>/dev/null 2>&1
    systemctl stop unionfs-encrypt 1>/dev/null 2>&1
    systemctl stop rclone-en 1>/dev/null 2>&1
    systemctl stop rclone-encrypt 1>/dev/null 2>&1
    systemctl stop move-en 1>/dev/null 2>&1
fi

##################### If Running Encrypted RClone, Turn This On
file="/var/plexguide/rclone/en"
if [ -e "$file" ]
then
    echo ">>> Running Encrypted RClone"
    echo ""
    systemctl disable unionfs 1>/dev/null 2>&1
    systemctl disable rclone 1>/dev/null 2>&1
    systemctl disable move 1>/dev/null 2>&1
    systemctl stop unionfs 1>/dev/null 2>&1
    systemctl stop rclone 1>/dev/null 2>&1
    systemctl stop move 1>/dev/null 2>&1

    systemctl enable unionfs-encrypt 1>/dev/null 2>&1
    systemctl enable rclone-en 1>/dev/null 2>&1
    systemctl enable rclone-encrypt 1>/dev/null 2>&1
    systemctl enable rclone 1>/dev/null 2>&1
    systemctl enable move-en 1>/dev/null 2>&1
    systemctl start unionfs-encrypt 1>/dev/null 2>&1
    systemctl start rclone-encrypt 1>/dev/null 2>&1
    systemctl start rclone-en 1>/dev/null 2>&1
    systemctl start rclone 1>/dev/null 2>&1
    systemctl start move-en 1>/dev/null 2>&1
fi
