#!/bin/bash

clear
cat << EOF
Directory 1 (For Google Drive)
WARNING: Write this down and follow the order

N < For New remote
gdrive < for the name
9 < For Google Drive (double check the number select incase)
Enter Your Google ID
Enter Your Google Secret

Y < for GUI Interface (much easier if using a Graphical Interface)
N < for headless machine (if using only Terminal)

Enter Your Verification Code

Windows Users: Use CTRL+Insert (for copy) and Shift+Insert (for Paste)
Do anything else, you will mess it up 

N < Configure this as a team drive?
Y < If asking all is ok?

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh

cat << EOF
Directory 2 (Local Drive)
WARNING: Write this down and follow the order

N < For New remote
local < for the name
11 < For a Local Drive

Ignore this part about ... long file names, UNC, and selecting [1])
>>> Just type this exactly: /mnt/rclone-move and then press [ENTER]

Y < Is asking all is ok?
Q < to quit

EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

rclone config

# disable the encrypted services to prevent a clash
systemctl disable rclone-en
systemctl disable move-en
systemctl stop rclone-en
systemctl stop move-en

# stop current services
systemctl stop unionfs
systemctl stop rclone
systemctl stop move

# ensure that the unencrypted services are on
systemctl enable rclone
systemctl enable move

# turn services back on
systemctl start unionfs
systemctl start rclone
systemctl start move

# disable the encrypted services to prevent a clash
systemctl disable rclone-en
systemctl disable move-en
systemctl stop rclone-en
systemctl stop move-en

# stop current services
systemctl stop unionfs
systemctl stop rclone
systemctl stop move

# copy rclone config from sudo user to root, which is the target
for i in `seq 1 5`;
do
cp ~/.config/rclone/rclone.conf /root/.config/rclone/
sleep 1
done

# ensure that the unencrypted services are on
systemctl enable rclone
systemctl enable move

# turn services back on
systemctl start unionfs
systemctl stop rclone
systemctl start rclone
systemctl start move

clear
cat << EOF
NOTE: You installed the encrypted version for the RClone data transport! If you
messed anything up, select [2] and run through again.  Also check:
http://unrclone.plexguide.com and or post on http://reddit.plexguide.com

HOW TO CHECK: In order to check if everything is working, have 1 item at least in 
your google Drive

1. Type: /mnt/rclone (and then you should see some item from your g-drive there)
2. Type: /mnt/rclone-union (and you should see the same g-drive stuff there)

Verifying that 1 and 2 are important due to this is how your data will sync!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh