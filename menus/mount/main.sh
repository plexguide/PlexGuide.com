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

#### Recalls from prior menu what user selected
selected=$( cat /var/plexguide/menu.select )

################################################################## UN OR ENCRYPTED

HEIGHT=11
WIDTH=42
CHOICE_HEIGHT=3
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive /w $selected"
MENU="Select a Version:"

OPTIONS=(A "PGDrives: Unencrypt"
         B "PGDrives: Encrypted (NOT READY)"
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
        echo "unencrypted" > /var/plexguide/pgdrives_format 1>/dev/null 2>&1
        #### Continues Onward
        ;;
        B)
        echo "encrypted" > /var/plexguide/pgdrives_format 1>/dev/null 2>&1
        #### Halted, NOT READY
        dialog --title "WARNING!" --msgbox "\nPGDrives Encrypted is Not Ready\n\nUse the PLEXDRIVE Traditional Method for Now" 0 0
        
        ##recommend this forwards to another script/menu when it works
        ##bash /opt/plexguide/menus/mount/encrypted.sh
        exit
        ;;
########## Deploy End
esac

################################################################## CORE

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

clear
curl https://rclone.org/install.sh | sudo bash -s beta
sleep 1
dialog --title "RClone Status" --msgbox "\nThe LATEST RCLONE Beta is now Installed!" 0 0

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
            cp ~/.config/rclone/rclone.conf /root/.config/rclone/rclone.conf
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
            
            #### BLANK OUT PATH - This Builds For UnionFS
            rm -r /tmp/path 1>/dev/null 2>&1
            touch /tmp/path 1>/dev/null 2>&1

            #### IF EXIST - DEPLOY
            if [ "$tdrive" == "[tdrive]" ]
              then

              #### ADDS TDRIVE to the UNIONFS PATH
              echo -n "/mnt/tdrive=RO:" >> /tmp/path
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tdrive
            fi

            if [ "$gdrive" == "[gdrive]" ]
              then

              #### ADDS GDRIVE to the UNIONFS PATH
              echo -n "/mnt/gdrive=RO:" >> /tmp/path
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

            #### RECALL VARIABLES START
            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            #### RECALL VARIABLES END 

            #### BASIC CHECKS to STOP Deployment - START
            if [ "$selected" == "Move" || "$gdrive" !="[gdrive]" ]
              then
            dialog --title "WARNING!" --msgbox "\nYou are UTILZING PGMove!\n\nTo work, you MUST have a gdrive\nconfiguration in RClone!" 0 0
            fi

            if [ "$selected" == "SuperTransfer2" || "$tdrive" !="[tdrive]" ]
              then
            dialog --title "WARNING!" --msgbox "\nYou are UTILZING PGMove!\n\nTo work, you MUST have a tdrive\nconfiguration in RClone!" 0 0
            fi

            #### DEPLOY a TRANSFER SYSTEM - START
            if [ "$selected" == "Move" ]
              then
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags move
            else
              systemctl stop move 1>/dev/null 2>&1
              systemctl disable move 1>/dev/null 2>&1
              clear
              bash /opt/plexguide/scripts/supertransfer/config.sh
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2
              journalctl -f -u supertransfer2       
            fi
            #### DEPLOY a TRANSFER SYSTEM - END
            ;;

        E)
            ;;
        Z)
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/mount/main.sh