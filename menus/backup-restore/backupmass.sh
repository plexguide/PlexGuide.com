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
            sudo bash /opt/plexguide/menus/backup-restore/main.sh
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

docker ps -a --format "{{.Names}}" > /opt/appdata/plexguide/running
sed -i -e "/watchtower/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/netdata/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/traefik/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/traefikv2/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1

#### Commenting Enables to See Everything
while read p; do
  echo $p > /tmp/program_var

app=$( cat /tmp/program_var )
if [ "$app" == "plex" ]
  then
    ### IF PLEX, execute this
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup_normal,backup_plex 
else
    ### IF NOT PLEX, execute this
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup_normal,backup_other
fi

done </opt/appdata/plexguide/running

read -n 1 -s -r -p "Press any key to continue"

rm -r /opt/appdata/plexguide/backup 1>/dev/null 2>&1
dialog --title "PG Backup Status" --msgbox "\nMass Application Backup Complete!" 0 0
clear

exit 0
