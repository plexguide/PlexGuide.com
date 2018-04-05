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

dialog --infobox "Backup: Starting Processing" 3 37 ; sleep 1

  echo "Mass Backup Started" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

d=$(date +%Y-%m-%d-%T) 1>/dev/null 2>&1

touch /opt/appdata/plexguide/backup 1>/dev/null 2>&1
sudo rm -r /opt/appdata/plex/trans* 1>/dev/null 2>&1

mfolder="/mnt/gdrive/plexguide/backup.old/backup-"
mpath="$mfolder$d"

mkdir /mnt/gdrive/plexguide/backup.old/ 1>/dev/null 2>&1
mkdir $mpath
mv /mnt/gdrive/plexguide/backup/* $mpath 1>/dev/null 2>&1

docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running

while read p; do
  echo $p > /tmp/program_var
  app=$( cat /tmp/program_var )
  dialog --infobox "Backing Up App: $app" 3 37
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup 1>/dev/null 2>&1

  echo "$app: Backup Complete" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
done </opt/appdata/plexguide/running

rm -r /mnt/gdrive/plexguide/backup/watchtower.tar 1>/dev/null 2>&1
rm -r /opt/appdata/plexguide/backup 1>/dev/null 2>&1

dialog --title "PG Backup Status" --msgbox "\nMass Application Backup Complete!" 0 0
clear

  echo "Mass Backup Complete!" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

sudo bash /opt/plexguide/menus/backup-restore/main.sh
exit 0
