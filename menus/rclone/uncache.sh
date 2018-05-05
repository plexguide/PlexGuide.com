#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################

## Installing RClone
#curl https://rclone.org/install.sh | sudo bash 

curl https://rclone.org/install.sh | sudo bash -s beta
############################################# RCLONE
## Executes RClone Config
rclone config

# echo 'a) Automatic Rclone Config (warning: in development)'
# echo 'm) Manual Rclone Config'
# echo 'w) Take Me To The PG Install Guide Wiki'
# echo 'e) Exit Rclone Config'
# read -p 'a/m/w/e>' c
#
# case $c in
#   a)
#     echo "Do You Have a Google Buisness/Enterprise/Student Account with:"
#     echo "1. Gdrive API access enabled"
#     echo "2. OAuth client ID ready"
#     echo "3. OAuth client secret ready"
#     read -p 'y/n>' a
#       case $a in
#       n) echo "Please go to https://console.developers.google.com and enable API access."
#          echo "PG Wiki For generating API keys: https://bit.ly/2vnFBxW"
#          read -p 'Press any key to continue... '
#          choice1 ;;
#       y)
#          # dynamic naming of rclone gdrive remote
#          if [[ $(rclone listremotes | grep gdrive2) ]]; then
#            gdrive_name='gdrive3'
#          elif [[ $(rclone listremotes | grep gdrive1) ]]; then
#            gdrive_name='gdrive2'
#          elif [[ $(rclone listremotes | grep gdrive) ]]; then
#            gdrive_name='gdrive1'
#          else
#            gdrive_name='gdrive'
#          fi
#
#          read -p 'Enter your Client ID: ' clientid
#          read -p 'Enter your Client Secret: ' clientsecret
#          # validate id
#          [[ $(echo $clientid | wc -c) > 60 && $(echo $clientid | grep 'apps.googleusercontent.com') ]] || \
#           echo "Invalid Client ID!" && read -p 'Press any key to try again... ' && exit 1
#          [[ $(echo $clientsecret | wc -c) > 17 ]] || \
#           echo "Invalid Client Secret!" && read -p 'Press any key to try again... ' && exit 1
#
#          # check if tcl expect is avaible & install if needed
#          [[ ! $(which expect) ]] && echo -e "Missing Dependency: expect\nInstalling..." \
#             && sleep 1.5 && sudo apt install expect -y
#
         # run tcl expect on rclone config
              # expect - "$clientid" "$clientsecret" "$gdrive_name"<<'EOF'
              #     lassign $argv clientid clientsecret gdrive_name
              #     spawn /usr/bin/rclone config
              #     expect "New remote"
              #     send "n\r"
              #     expect "name>"
              #     send "$gdrive_name\r"
              #     expect "11 / Google Drive"
              #     send "11\r"
              #     expect "client_id>"
              #     send "$clientid\r"
              #     expect "client_secret>"
              #     send "$clientsecret\r"
              #     expect "scope>"
              #     send "1\r"
              #     expect "root_folder_id>"
              #     send "/\r"
              #     expect "service_account_file>"
              #     send "\r"
              #     expect "y/n>"
              #     send "n\r"
              #     interact "\r" return
              # EOF
#       ;;
#
#   m) rclone config ;;
#   w) echo "PG Wiki For Rclone: https://bit.ly/2JQrqV9"
#      echo "PG Wiki For generating API keys: https://bit.ly/2vnFBxW"
#      read -p 'Press any key to continue... '
#      choice1 ;;
#   e) bash /opt/plexguide/menus/main.sh ;;
#   *) echo "Invalid Choice"
#      read -p 'Press any key to continue... '
#      exit 1 ;;
# esac

# allows others to access fuse
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF

mkdir -p /root/.config/rclone/ 1>/dev/null 2>&1

## Copying to /mnt incase
cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags cache

## RClone Script
chmod 755 /opt/appdata/plexguide/rclone.sh 1>/dev/null 2>&1

## Create the Move Script
chmod 755 /opt/appdata/plexguide/move.sh 1>/dev/null 2>&1

###### Ensure Changes Are Reflected
#sudo systemctl daemon-reload

systemctl restart cache 1>/dev/null 2>&1
# set variable to remember what version of rclone user installed
mkdir -p /var/plexguide/rclone 1>/dev/null 2>&1
touch /var/plexguide/rclone/cache-un 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/un 1>/dev/null 2>&1
rm -r /var/plexguide/rclone/en 1>/dev/null 2>&1

# pauses
bash /opt/plexguide/scripts/docker-no/continue.sh
