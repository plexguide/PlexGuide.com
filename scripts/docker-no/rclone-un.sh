#!/bin/bash


## Warning
clear
cat << EOF
NOTE: You are making TWO directories for rclone.  One is local and the
other is for googledrive.

WARNING: It is highly recommended for you to goto http://unrclone.plexguide.com 
if you are very new to rclone! Write these instructions down below for each 
new directory!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh

clear
cat << EOF
Directory 1 (For Google Drive)
WARNING: Write this down and follow the order

* [N] New Remote 
* [9] Google, 
* Enter Info, 
* Verify
* Ok
* Continue

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh

clear
cat << EOF
Directory 2 (Local Drive)
WARNING: Write this down and follow the order

* [N]  New Remote 
* [11] Local 
* [Type] /mnt/rclone-move (ignore the longfile prompt, just type this)
* Verify
* Ok
* Quit

OF
bash /opt/plexguide/scripts/docker-no/continue.sh

clear

rclone config

systemctl stop rclone
systemctl stop unionfs
systemctl stop move

cp ~/.config/rclone/rclone.conf /root/.config/rclone/

systemctl restart rclone
systemctl restart unionfs
systemctl restart move