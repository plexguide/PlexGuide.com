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
echo 'INFO - @Unencrypted PG Blitz Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

################################################################## CORE

HEIGHT=12
WIDTH=46
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive /w PG Blitz"
MENU="Make a Selection:"

OPTIONS=(A "Deploy RClone    : Configs"
         B "Deploy JSON Files: TeamDrive"
         C "Deploy PG Drive  : Mount"
         D "Deploy PG Blitz  : Transfer"
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
echo 'INFO - Configured RCLONE for PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

            #### RClone Missing Warning - END
            rclone config
            touch /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
            #### GREP Checks
            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            mkdir -p /root/.config/rclone/
            chown -R 1000:1000 /root/.config/rclone/
            cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
            #################### installing dummy file for prep of pgdrive deployment
            file="/mnt/unionfs/plexguide/pgchecker.bin"
            if [ -e "$file" ]
            then
               echo 'PASSED - UnionFS is Properly Working - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            else
               mkdir -p /mnt/tdrive/plexguide/ 1>/dev/null 2>&1
               mkdir -p /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
               mkdir -p /tmp/pgchecker/ 1>/dev/null 2>&1
               touch /tmp/pgchecker/pgchecker.bin 1>/dev/null 2>&1
               rclone copy /tmp/pgchecker gdrive:/plexguide/ &>/dev/null &
               rclone copy /tmp/pgchecker tdrive:/plexguide/ &>/dev/null &
               echo 'INFO - Deployed PGChecker.bin - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            fi
            ;;
        B)
            echo 'INFO - DEPLOYED JSON FILES' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            #### Deploy CloudBlitz
            clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudblitz --extra-vars "skipend="yes
            #### Note How to Create Json files
            dialog --title "NOTE" --msgbox "\nVisit Port 7997 and Upload your JSON files\n\nKeys are Stored below for Processing:\n/opt/appdata/pgblitz/keys/unprocessed/\n\nWhen Finished, Press [ENTER] to Continue!" 0 0
            clear
            echo "Stopping CloudBlitz"
            docker stop cloudBlitz
            echo "Removing CloudBlitz"
            docker rm cloudBlitz
            ;;
        C)
            echo 'INFO - DEPLOYED PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

            #### RECALL VARIABLES START
            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            #### RECALL VARIABLES END

            ### Checkers
            if [ "$gdrive" != "[gdrive]" ]; then
              echo 'FAILURE - Must Configure gdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
              dialog --title "WARNING!" --msgbox "\nGDrive for RClone Must be Configured!\n\nThis is required to BackUp/Restore any PG Data!" 0 0
              bash /opt/plexguide/roles/pgblitz/scripts/main.sh
              exit
            fi

            if [ "$tdrive" != "[tdrive]" ]; then
              echo 'FAILURE - USING ST2: Must Configure tdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
              dialog --title "WARNING!" --msgbox "\nTDrive for RClone Must be Configured!\n\nThis is required for TeamDrives to Work!!" 0 0
              bash /opt/plexguide/roles/pgblitz/scripts/main.sh
              exit
            fi

            #### REQUIRED TO DEPLOY STARTING
            ansible-playbook /opt/plexguide/pg.yml --tags pgdrive_standard
            #ansible-playbook /opt/plexguide/scripts/test/check-remove/tasks/main.yml

            #### BLANK OUT PATH - This Builds For UnionFS
            rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
            touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

            #### IF EXIST - DEPLOY
            if [ "$tdrive" == "[tdrive]" ]
              then

              #### ADDS TDRIVE to the UNIONFS PATH
              echo -n "/mnt/tdrive=RO:" >> /var/plexguide/unionfs.pgpath
              ansible-playbook /opt/plexguide/pg.yml --tags tdrive
            fi

            if [ "$gdrive" == "[gdrive]" ]
              then

              #### ADDS GDRIVE to the UNIONFS PATH
              echo -n "/mnt/gdrive=RO:" >> /var/plexguide/unionfs.pgpath
              ansible-playbook /opt/plexguide/pg.yml --tags gdrive
            fi
            bash /opt/plexguide/roles/pgblitz/scripts/ufbuilder.sh
            #### REQUIRED TO DEPLOY ENDING
            ansible-playbook /opt/plexguide/pg.yml --tags unionfs
            #ansible-playbook /opt/plexguide/pg.yml --tags ufsmonitor

            read -n 1 -s -r -p "Press any key to continue"
            dialog --title "NOTE" --msgbox "\nPG Drive Deployed!!" 0 0
            ;;
        D)
            #### RECALL VARIABLES START
            tdrive=$(grep "tdrive" /root/.config/rclone/rclone.conf)
            gdrive=$(grep "gdrive" /root/.config/rclone/rclone.conf)
            #### RECALL VARIABLES END

            #### BASIC CHECKS to STOP Deployment - START
            if [ "$gdrive" != "[gdrive]" ]; then
              echo 'FAILURE - Must Configure gdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
              dialog --title "WARNING!" --msgbox "\nGDrive for RClone Must be Configured!\n\nThis is required to BackUp/Restore any PG Data!" 0 0
              bash /opt/plexguide/roles/pgblitz/scripts/main.sh
              exit
            fi

            if [ "$tdrive" != "[tdrive]" ]; then
              echo 'FAILURE - USING ST2: Must Configure tdrive for RCLONE' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
              dialog --title "WARNING!" --msgbox "\nTDrive for RClone Must be Configured!\n\nThis is required for TeamDrives to Work!!" 0 0
              bash /opt/plexguide/roles/pgblitz/scripts/main.sh
              exit
            fi
            #### DEPLOY a TRANSFER SYSTEM - START
              clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudblitz
              echo ""
              read -n 1 -s -r -p "Press any key to continue"
            #### DEPLOY a TRANSFER SYSTEM - END
            dialog --title "NOTE!" --msgbox "\nPG Blitz is Now Running!" 7 38
            echo 'SUCCESS - PG Blitz is Now Running!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            ;;
        Z)
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/roles/pgblitz/scripts/main.sh
