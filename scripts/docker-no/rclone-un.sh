#!/bin/bash


## Warning
clear
cat << EOF
Warning: You are going to make two rclone directories. Please visit
http://unrclone.plexguide.com for a copy of the rclone instructions or
follow the quick instructions below.

Google Drive
[N] New Remote [9] Google, Enter Info, Verify, Ok, and then continue

Local Drive
[N] New Remote [11] Local, ignore the longfile name info,
type /mnt/rclone-move, OK, and then quit
EOF
echo

bash /opt/plexguide/scripts/docker-no/continue.sh
clear

rclone config

cp ~/.config/rclone/rclone.conf /root/.config/rclone/
