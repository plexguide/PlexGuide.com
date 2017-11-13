#!/bin/bash

## For Google Drive
clear
cat << EOF
Maintained By - Deiteq
Directory 1 (For Google Drive)
WARNING: Write this down and follow the order or http://unrclone.plexguide.com

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

####### For Encryption Part 1
Maintained By - Deiteq
cat << EOF
Part I Encryption
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
gcrypt < for the name
6 < For Encrypt/Decrypt (double check the number select incase)
gdrive:/encrypt (encrypt being the rclone encrypted folder within your gdrive)
2 < Encrypt standard
Y < type your own password (write it, secure it and do not lose it)
Y < type your own salt password (write it, secure it, make different)
Should see something like this:

[gcrypt]
remote = gdrive:/encrypt
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***

Y < Is asking all is ok?

EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

####### For Encryption Part 2
Maintained By - Deiteq
cat << EOF
Part II Encryption
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
crypt < for the name
6 < For Encrypt/Decrypt (double check the number select incase)
/mnt/plexdrive4/encrypt
2 < Encrypt standard
Y < type your own password (write it, secure it and do not lose it)
Y < type your own salt password (write it, secure it, make different)
Should see something like this:

[crypt]
remote = /mnt/plexdrive4/encrypt
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***

Y < Is asking all is ok?

EOF

bash /opt/plexguide/scripts/docker-no/continue.sh

##### For Encryption Part II
cat << EOF
Maintained By - Deiteq
Loca Drive
WARNING: Write this down and follow the order or http://enrclone.plexguide.com

N < For New remote
local < for the name
11 < For a Local Drive

Ignore this part about ... long file names, UNC, and selecting [1])
>>> Just type this exactly: /mnt/rclone-move and then press [ENTER]

Y < Is asking all is ok?
Q < to quit

EOF

rclone config
bash /opt/plexguide/script/docker-no/rclone-config.sh

bash /opt/plexguide/scripts/docker-no/continue.sh

# disable the unencrypted services to prevent a clash
systemctl disable rclone
systemctl disable move
systemctl stop rclone
systemctl stop move

# stop current services
systemctl stop unionfs
systemctl stop rclone-en
systemctl stop move-en

# copy rclone config from sudo user to root, which is the target
cp ~/.config/rclone/rclone.conf /root/.config/rclone/

# ensure that the encrypted services are on
systemctl enable rclone-en
systemctl enable move-en

# turn services back on
systemctl restart unionfs
systemctl restart rclone-en
systemctl restart move-en

######################### REPEATS TO MAKE IT WORK
# disable the unencrypted services to prevent a clash
systemctl disable rclone
systemctl disable move
systemctl stop rclone
systemctl stop move

# stop current services
systemctl stop unionfs
systemctl stop rclone-en
systemctl stop move-en

# copy rclone config from sudo user to root, which is the target
cp ~/.config/rclone/rclone.conf /root/.config/rclone/

# ensure that the encrypted services are on
systemctl enable rclone-en
systemctl enable move-en

# turn services back on
systemctl restart unionfs
systemctl restart rclone-en
systemctl restart move-en

clear
cat << EOF
NOTE: You installed the encrypted version for the RClone data transport! If you
messed anything up, select [2] and run through again.  Also check:
http://enrclone.plexguide.com and or post on http://reddit.plexguide.com

HOW TO CHECK: In order to check if everything is working, have 1 item at least
in your google Drive

1. Type: /mnt/rclone (and then you should see some item from your g-drive there)
2. Type: /mnt/rclone-union (and you should see the same g-drive stuff there)

Verifying that 1 and 2 are important due to this is how your data will sync!

To make this easy, you can also use the checking tools built in!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh
