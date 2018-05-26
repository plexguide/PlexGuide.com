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

#### PUT AN IF For Type Menus Selected

#file="/var/plexguide/pgdupes.autodelete"
#if [ -e "$file" ]
#then
#    echo "" 1>/dev/null 2>&1
#else
#    echo "ON" > /var/plexguide/pgdupes.autodelete
#    echo "true" > /var/plexguide/pgdupes.autodelete2.json
#    exit
#fi

stat=$( cat /var/plexguide/pgdupes.autodelete )
selected=$( cat /var/plexguide/menu.select )

HEIGHT=14
WIDTH=42
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive /w $selected"
MENU="Make a Selection:"

OPTIONS=(A "Install: RClone"
         B "Config : RClone"
         C "Deploy : PGDrive"
         D "Deploy : $selected"
         E "Deploy : PGScan (NOTREADY)"
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
################# Needed FOR RCLONE
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF
            chown 1000:1000 /usr/bin/rclone 1>/dev/null 2>&1
            chmod 755 /usr/bin/rclone 1>/dev/null 2>&1
            ;;
        B)
            #### RClone Missing Warning - START
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First" 0 0
                  bash /opt/plexguide/menus/mount/main.sh
                  exit
              fi
            #### RClone Missing Warning - END
            rclone config
            touch /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
            #### GREP Checks
            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            ;;
        C)
            #### RCLONE MISSING START
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First" 0 0
                  bash /opt/plexguide/menus/mount/main.sh
                  exit
              fi
            #### RCLONE MISSING END

            #### RECALL VARIABLES START
            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            #### RECALL VARIABLES END 

            #### REQUIRED TO DEPLOY STARTING
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pgdrives_standard
            
            #### IF EXIST - DEPLOY
            if [ "$tdrive" == "[tdrive]" ]
              then
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tdrive
            fi

            if [ "$gdrive" == "[gdrive]" ]
              then
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags gdrive
            fi

            #### REQUIRED TO DEPLOY ENDING
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unionfs

            dialog --title "NOTE" --msgbox "\nPG Drive Deployed!!" 0 0
            ;;
        D)
            #### RClone Missing Warning -START
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First" 0 0
                  bash /opt/plexguide/menus/mount/main.sh
                  exit
              fi
            #### RClone Missing Warning - END
            clear
            bash /opt/plexguide/scripts/supertransfer/config.sh
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2
            journalctl -f -u supertransfer2
            ;;

        E)
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/mounts/main.sh
