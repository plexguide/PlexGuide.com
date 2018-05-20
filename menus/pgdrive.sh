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
export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com

file="/var/plexguide/pgdupes.autodelete"
if [ -e "$file" ]
then
    echo "" 1>/dev/null 2>&1
else
    echo "ON" > /var/plexguide/pgdupes.autodelete
    echo "true" > /var/plexguide/pgdupes.autodelete2.json
    exit
fi

stat=$( cat /var/plexguide/pgdupes.autodelete )

HEIGHT=8
WIDTH=44
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive UnEncrypted Edition"
MENU="Make a Selection:"

OPTIONS=(A "Install: RClone"
         B "Deploy : PGDrive"
         C "Deploy : Transfer a System"
         D "Deploy : PGScan (NOTREADY)"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)
        
# allows others to access fuse
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pgcache_rclone #1>/dev/null 2>&1
            chown 1000:1000 /usr/bin/rclone 1>/dev/null 2>&1
            chmod 755 /usr/bin/rclone 1>/dev/null 2>&1
            rclone config
            touch /mnt/gdrive/plexguide/
            ;;
        B)
            #### RClone Mising Warning
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First" 0 0
                  bash /opt/plexguide/menus/pgdrive/main.sh
                  exit
              fi

            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pgcache_deploy #1>/dev/null 2>&1
            ;;
        C)
            #### RClone Mising Warning
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First" 0 0
                  bash /opt/plexguide/menus/pgdrive/main.sh
                  exit
              fi

            clear
            bash /opt/plexguide/scripts/supertransfer/config.sh
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2
            journalctl -f -u supertransfer2
            ;;

        D)
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/pgdrive/main.sh
