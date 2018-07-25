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
WIDTH=43
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PGDrive /w PG Blitz"
MENU="Make a Selection:"

OPTIONS=(A "RClone: Config & Establish"
         B "JSON  : For TeamDrive"
         C "Deploy: PG Drive & PG Blitz"
         D "Tshoot: Remove All Keys (Baseline)"
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
            clear && ansible-playbook /opt/plexguide/pg.yml --tags cloudblitz --extra-vars "skipend="yes --skip-tags cron
            #### Note How to Create Json files
            dialog --title "NOTE" --msgbox "\nVisit Port 7997 and Upload your JSON files\n\nKeys are Stored below for Processing:\n/opt/appdata/pgblitz/keys/unprocessed/\n\nWhen Finished, Press [ENTER] to Continue!" 0 0
            dialog --infobox "Please Wait" 3 22
            docker stop cloudblitz 1>/dev/null 2>&1
            docker rm cloudblitz 1>/dev/null 2>&1
            bash /opt/plexguide/roles/pgblitz/scripts/list.sh
            bash /opt/plexguide/roles/pgblitz/scripts/gdsa.sh
            dialog --title "NOTE" --msgbox "\nJSON Keys Processed" 0 0
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

            #### BLANK OUT PATH - This Builds For UnionFS
            rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
            touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

            #### IF EXIST - DEPLOY
            if [ "$tdrive" == "[tdrive]" ]
              then

              #### ADDS TDRIVE to the UNIONFS PATH
              echo -n "/mnt/tdrive=RO:" >> /var/plexguide/unionfs.pgpath
            fi

            if [ "$gdrive" == "[gdrive]" ]
              then

              #### ADDS GDRIVE to the UNIONFS PATH
              echo -n "/mnt/gdrive=RO:" >> /var/plexguide/unionfs.pgpath
            fi
            bash /opt/plexguide/roles/pgblitz/scripts/ufbuilder.sh
            temp=$( cat /tmp/pg.gdsa.build )
            echo -n "$temp" >> /var/plexguide/unionfs.pgpath
            #### REQUIRED TO DEPLOY ENDING
            ansible-playbook /opt/plexguide/pg.yml --tags pgblitz
            #ansible-playbook /opt/plexguide/pg.yml --tags ufsmonitor

            read -n 1 -s -r -p "Press any key to continue"
            dialog --title "NOTE" --msgbox "\nPG Drive & PG Blitz Deployed!!" 0 0
            ;;
        D)
            dialog --infobox "Baselining PGBlitz (Please Wait)" 0 0
            sleep 2
            systemctl stop pgblitz 1>/dev/null 2>&1
            systemctl disable pgblitz 1>/dev/null 2>&1
            rm -r /root/.config/rclone/rclone.conf 1>/dev/null 2>&1
            rm -r /opt/appdata/pgblitz/keys/unprocessed/* 1>/dev/null 2>&1
            rm -r /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1
            rm -r /opt/appdata/pgblitz/keys/badjson/* 1>/dev/null 2>&1
            dialog --title "NOTE" --msgbox "\nKeys Cleared!\n\nYou must reconfigure RClone and Repeat the Process Again!" 0 0
            ;;
        Z)
            exit 0 ;;

########## Deploy End
esac

bash /opt/plexguide/roles/pgblitz/scripts/main.sh
