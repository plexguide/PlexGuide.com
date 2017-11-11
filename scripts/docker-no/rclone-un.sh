#!/bin/bash

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

EOF

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

clear
cat << EOF
NOTE: You installed the unencrypted version for the RClone data transport! If you
messed anything up, select [2] and run through again.  Also check:
http://unrclone.plexguide.com and or post on http://reddit.plexguide.com

HOW TO CHECK: In order to check if everything is working, have 1 item at least in 
your google Drive

1. Type: /mnt/rclone (and then you should see some item from your g-drive there)
2. Type: /mnt/rclone-union (and you should see the same g-drive stuff there)

Verifying that 1 and 2 are important due to this is how your data will sync!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh