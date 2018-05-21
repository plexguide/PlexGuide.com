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

HEIGHT=13
WIDTH=48
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive UnEncrypted Edition"
MENU="Make a Selection:"

OPTIONS=(A "Install: RClone"
         B "Deploy : PGDrive"
         C "Deploy : Transfer System"
         D "Deploy : PGScan (NOTREADY)"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
clear
curl https://rclone.org/install.sh | sudo bash -s beta
sleep 1
dialog --title "RClone Status" --msgbox "\nThe LATEST RCLONE Beta is now Installed!" 0 0

# allows others to access fuse
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
            clear
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
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First!" 0 0
                  bash /opt/plexguide/menus/pgdrive/main.sh
                  exit
              fi

            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags gdrive #1>/dev/null 2>&1
            ;;
        C)
            #### RClone Mising Warning
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First!" 0 0
                  bash /opt/plexguide/menus/pgdrive/main.sh
                  exit
              fi

##################################################### DEPLOYMENT SYSTEM - START
        HEIGHT=10
        WIDTH=40
        CHOICE_HEIGHT=4
        BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
        TITLE="Deploy a Mount System"

        OPTIONS=(A "PG Move      (Traditional)"
                 B "PG SuperTransfer 2   (New)"
                 C "Mini FAQ"
                 Z "Exit")

        CHOICE=$(dialog --backtitle "$BACKTITLE" \
                        --title "$TITLE" \
                        --menu "$MENU" \
                        $HEIGHT $WIDTH $CHOICE_HEIGHT \
                        "${OPTIONS[@]}" \
                        2>&1 >/dev/tty)
        case $CHOICE in
                A)
                    systemctl stop supertransfer2 1>/dev/null 2>&1
                    systemctl disable supertransfer2 1>/dev/null 2>&1
                    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags move
                    "PG Move" > /var/plexguide/deployed.system
                    ;;
                B)
                    systemctl stop move 1>/dev/null 2>&1
                    systemctl disable move 1>/dev/null 2>&1
                    clear
                    bash /opt/plexguide/scripts/supertransfer/config.sh
                    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2
                    journalctl -f -u supertransfer2
                    "PG ST2" > /var/plexguide/deployed.system
                    ;;
                C)
                    ;;
                Z)
                    ;; ## Do Not Put Anything Here
        esac
;;
##################################################### DEPLOYMENT SYSTEM - END
        D)
            ;;
        Z)
            clear
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/pgdrive/main.sh