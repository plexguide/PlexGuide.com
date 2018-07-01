#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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
echo 'INFO - @GCE Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

bash /opt/plexguide/roles/gce/gcechecker.sh

edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

HEIGHT=17
WIDTH=40
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="$edition - $version"

OPTIONS=(A "Configure RCLONE"
         B "Deploy PG Drive"
         C "PG SuperTransfer2"
         D "PG Traefik - Reverse Proxy"
         E "PG Programs"
         F "PG Server NET Benchmarks"
         G "PG Trak"
         H "PG Troubleshooting Actions"
         I "PG Backup & Restore"
         J "PG Updates"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
            clear
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
            mkdir -p /root/.config/rclone/
            chown -R 1000:1000 /root/.config/rclone/
            cp ~/.config/rclone/rclone.conf /root/.config/rclone/ 1>/dev/null 2>&1
echo 'INFO - Configured RClone for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

            ;;
        B)
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
            clear
            ansible-playbook /opt/plexguide/pg.yml --tags pgdrive_standard

####  See encrypt.sh for example of script below in use!
#
#            if dialog --stdout --title "PAY ATTENTION!" \
#              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
#              --yesno "\nAre you switching from PlexDrive to PGDrive?\n\nSelect No: IF this is a clean/fresh Server!" 0 0; then
#
#                ansible-role  services_remove
#            fi

            #### BLANK OUT PATH - This Builds For UnionFS
            rm -r /tmp/path 1>/dev/null 2>&1
            touch /tmp/path 1>/dev/null 2>&1

            #### IF EXIST - DEPLOY
            if [ "$tdrive" == "[tdrive]" ]
              then

              #### ADDS TDRIVE to the UNIONFS PATH
              echo -n "/mnt/tdrive=RO:" >> /tmp/path
              ansible-playbook /opt/plexguide/pg.yml --tags tdrive
            fi

            if [ "$gdrive" == "[gdrive]" ]
              then

              #### ADDS GDRIVE to the UNIONFS PATH
              echo -n "/mnt/gdrive=RO:" >> /tmp/path
              cat "/tmp/path" 1>/var/plexguide/unionfs.pgpath
              ansible-playbook /opt/plexguide/pg.yml --tags gdrive
            fi

            #### REQUIRED TO DEPLOY ENDING
            ansible-playbook /opt/plexguide/pg.yml --tags unionfs

            read -n 1 -s -r -p "Press any key to continue"
            dialog --title "NOTE" --msgbox "\nPG Drive Deployed!!" 0 0
echo 'INFO - PG Drive Deployed for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

            ;;
        C)
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
            if [[ "$tdrive" != "[tdrive]" ]]
              then
                dialog --title "WARNING!" --msgbox "\nYou are UTILZING PG SuperTransfer2!\n\nTo work, you MUST have a tdrive\nconfiguration in RClone!" 0 0
                bash /opt/plexguide/roles/gce.sh
              else
                systemctl stop move 1>/dev/null 2>&1
                systemctl disable move 1>/dev/null 2>&1
                clear
                bash /opt/plexguide/scripts/supertransfer/config.sh
echo 'INFO - Deploy SuperTranser2 for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
                ansible-playbook /opt/plexguide/pg.yml --tags supertransfer2
                journalctl -f -u supertransfer2
                dialog --infobox "Stopping & Removing CloudST2" 3 42
                sleep 1
                docker stop cloudst2
                docker rm cloudst2
            exit
            fi
            ;;
        D)
        echo 'INFO - Selected: PG Traefik - Reverse Proxy' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
                    touch /var/plexguide/traefik.lock
                    clear &&ansible-playbook /opt/plexguide/pg.yml --tags traefikdeploy
                    file="/var/plexguide/traefik.lock"
                    if [ -e "$file" ]
                      then
                        echo "" && read -n 1 -s -r -p "Did Not Complete Deployment! Press [ANY] Key to EXIT!"
                      else
                        echo "" && read -n 1 -s -r -p "We Must Rebuild Your Containers! Press [ANY] Key!"
                        bash /opt/plexguide/roles/traefikdeploy/scripts/rebuild.sh
                        echo "" && read -n 1 -s -r -p "Containers Rebuilt! Press any key to continue!"
                    fi
                    ;;
        E)
echo 'INFO - Selected to View Programs for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/roles/gce/programs.sh
            ;;
        F)
echo 'INFO - Selected to View BenchMarks for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/menus/benchmark/main.sh ;;
        G)
echo 'INFO - Selected to View PGTrak Menu for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/menus/pgtrak/main.sh
            ;;
        H)
echo 'INFO - Selected to View Info-TShoot for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/roles/info-tshoot/tshoot.sh ;;

        I)
echo 'INFO - Selected to View Backup-Restore for GCE' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/menus/backup-restore/main.sh ;;
        J)
echo 'INFO - Selected: PG Upgrades Menu Interface' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/scripts/upgrade/main.sh
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
        Z)
echo 'INFO - Selected: Exit GCE Main Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
esac

echo 'INFO - Looping: GCE Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
## repeat menu when exiting
bash /opt/plexguide/roles/gce.sh
