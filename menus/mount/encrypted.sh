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
echo 'INFO - @Encrypted PG Drive Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

#### Recalls from prior menu what user selected
selected=$( cat /var/plexguide/menu.select )
################################################################## CORE

HEIGHT=14
WIDTH=50
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive /w $selected"
MENU="Make a Selection:"

OPTIONS=(A "Install: RClone"
         B "Config : RClone"
         C "Deploy : PGDrive"
         D "Deploy : $selected"
         E "Remove old services - e.g. PlexDrive"
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
echo 'INFO - Installed RCLONE Beta for PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

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
echo 'INFO - Configured RCLONE for PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

            #### RClone Missing Warning - END
            rclone config
            touch /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
            #### GREP Checks
            tcrypt=$(grep "tcrypt" /root/.config/rclone/rclone.conf)
            gcrypt=$(grep "gcrypt" /root/.config/rclone/rclone.conf)
            mkdir -p /root/.config/rclone/
            chown -R 1000:1000 /root/.config/rclone/
            cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
            #################### installing dummy file for prep of pgdrive deployment
            file="/mnt/unionfs/plexguide/pgchecker.bin"
            if [ -e "$file" ]
            then
               echo 'PASSED - UnionFS is Properly Working - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            else
               mkdir -p /mnt/tdrive/plexguide/ 1>/dev/null 2>&1
               mkdir -p /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
               mkdir -p /tmp/pgchecker/ 1>/dev/null 2>&1
               touch /tmp/pgchecker/pgchecker.bin 1>/dev/null 2>&1
               rclone copy /tmp/pgchecker gcrypt:/plexguide/ &>/dev/null &
               rclone copy /tmp/pgchecker tcrypt:/plexguide/ &>/dev/null &
               echo 'INFO - Deployed PGChecker.bin - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            fi
            ;;
        C)
            #### RCLONE MISSING START
            file="/usr/bin/rclone" 1>/dev/null 2>&1
              if [ -e "$file" ]
                then
                  echo "" 1>/dev/null 2>&1
                else
                echo 'WARNING - You Must Install RCLONE First' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
                  dialog --title "WARNING!" --msgbox "\nYou Need to Install RClone First" 0 0
                  bash /opt/plexguide/menus/mount/main.sh
                  exit
              fi
            #### RCLONE MISSING END
echo 'INFO - DEPLOYED PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

            #### RECALL VARIABLES START
#            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
#            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            tcrypt=$(grep "tcrypt" /root/.config/rclone/rclone.conf)
            gcrypt=$(grep "gcrypt" /root/.config/rclone/rclone.conf)
            #### RECALL VARIABLES END

            #### REQUIRED TO DEPLOY STARTING
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pgdrive_standard_en

#            if dialog --stdout --title "PAY ATTENTION!" \
#              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
#              --yesno "\nAre you switching from PlexDrive to PGDrive?\n\nSelect No: IF this is a clean/fresh Server!" 0 0; then

#                ansible-role  services_remove
            #fi

            #### BLANK OUT PATH - This Builds For UnionFS
            rm -r /tmp/path 1>/dev/null 2>&1
            touch /tmp/path 1>/dev/null 2>&1

            #### IF EXIST - DEPLOY
            if [ "$tcrypt" == "[tcrypt]" ]
              then

              #### ADDS TCRYPT to the UNIONFS PATH
              echo -n "/mnt/tdrive=RO:" >> /tmp/path
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tcrypt
            fi

            if [ "$gcrypt" == "[gcrypt]" ]
              then

              #### ADDS GCRYPT to the UNIONFS PATH
              echo -n "/mnt/gdrive=RO:" >> /tmp/path
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags gcrypt
            fi

            #### REQUIRED TO DEPLOY ENDING
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unionfs_en
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ufsmonitor

            read -n 1 -s -r -p "Press any key to continue"
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
#            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
#            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            tcrypt=$(grep "tcrypt" /root/.config/rclone/rclone.conf)
            gcrypt=$(grep "gcrypt" /root/.config/rclone/rclone.conf)
            #### RECALL VARIABLES END

            #### BASIC CHECKS to STOP Deployment - START
            if [[ "$selected" == "Move" && "$gcrypt" != "[gcrypt]" ]]
              then
echo 'FAILURE - Using MOVE: Must Configure gdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            dialog --title "WARNING!" --msgbox "\nYou are UTILZING PG Move!\n\nTo work, you MUST have a gcrypt\nconfiguration in RClone!" 0 0
            bash /opt/plexguide/menus/mount/encrypted.sh
            exit
            fi

            if [[ "$selected" == "SuperTransfer2" && "$tcrypt" != "[tcrypt]" ]]
              then
echo 'FAILURE - USING ST2: Must Configure tdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            dialog --title "WARNING!" --msgbox "\nYou are UTILZING PG SuperTransfer2!\n\nTo work, you MUST have a tcrypt\nconfiguration in RClone!" 0 0
            bash /opt/plexguide/menus/mount/encrypted.sh
            exit
            fi

            #### DEPLOY a TRANSFER SYSTEM - START
            if [ "$selected" == "Move" ]
              then
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags move_en
              read -n 1 -s -r -p "Press any key to continue"
            else
              systemctl stop move 1>/dev/null 2>&1
              systemctl disable move 1>/dev/null 2>&1
              clear
              bash /opt/plexguide/scripts/supertransfer-encrypted/config.sh
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags supertransfer2_encrypt
              journalctl -f -u supertransfer2
              read -n 1 -s -r -p "Press any key to continue"
            fi
            #### DEPLOY a TRANSFER SYSTEM - END
            dialog --title "NOTE!" --msgbox "\n$selected is now running!" 7 38
            echo 'SUCCESS - $selected is now running!' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

            ;;

        E)
          ansible-role services_remove
          dialog --title " All Google Related Services Removed!" --msgbox "\nPlease re-run:-\n             'Deploy : PGDrive'\n     and     'Deploy : $selected'" 0 0
          ;;
        Z)
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/menus/mount/encrypted.sh
