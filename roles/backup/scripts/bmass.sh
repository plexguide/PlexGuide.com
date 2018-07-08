#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
echo 'INFO - @Backup Mass Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
server=$( cat /var/plexguide/server.id )

export NCURSES_NO_UTF8_ACS=1

if dialog --stdout --title "Backup Mass Confirmation" \
            --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
            --yesno "\nDo you want to BACKOUT & EXIT from making a Mass Backup?" 0 0; then
            dialog --title "PG Backup Status" --msgbox "\nExiting! User selected NOT to BACKUP!" 0 0
            sudo bash /opt/plexguide/roles/backup-restore-nav/main.sh
            exit 0
        else
            clear
        fi

dialog --infobox "Backup: Starting Process" 3 37 ; sleep 1

d=$(date +%Y-%m-%d-%T) 1>/dev/null 2>&1

touch /opt/appdata/plexguide/backup 1>/dev/null 2>&1
sudo rm -r /opt/appdata/plex/trans* 1>/dev/null 2>&1

mfolder="/mnt/gdrive/plexguide/backup.old/$server/backup-$d"

mkdir -p $mfolder 1>/dev/null 2>&1
mv /mnt/gdrive/plexguide/backup/$server/* $mfolder 1>/dev/null 2>&1

bash /opt/plexguide/roles/backup/scripts/list.sh
#### Commenting Enables to See Everything
while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/pg.yml --tags backup
  echo ""
  echo "$p Backed Up"
  sleep 5
done </tmp/backup.list

read -n 1 -s -r -p "Mass Backup Process - Completed [PRESS ANY KEY to CONTINUE]"

rm -r /opt/appdata/plexguide/backup 1>/dev/null 2>&1
echo 'INFO - Mass Backup Complete!' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
dialog --title "PG Backup Status" --msgbox "\nMass Application Backup Complete!" 0 0
clear

exit 0
