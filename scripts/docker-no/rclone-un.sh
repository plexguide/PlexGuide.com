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

## Going to rclone-un2 after