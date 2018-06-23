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

#######################
echo "yes" > /var/plexguide/server.wp
base="/mnt/gdrive/plexguide/wordpress/"

dialog --title "[ EXAMPLE: SERVER01 or plexguide.com ]" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Type the Wordpress Subdomain/ID: " 8 50 2>/var/plexguide/wp.temp.id
id=$(cat /var/plexguide/wp.temp.id)

  if dialog --stdout --title "WP Server Subdomain/ID Restore" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nWP BACKUP ID: $id\n\nCorrect?" 0 0; then
    ### Ensure Location Get Stored for Variables Role
    echo "$id" > /var/plexguide/wp.id
  else
    dialog --title "Server ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/backup-restore/first.sh
      exit
  fi

############################## Ensure It Does Not EXIST LOCAL
file="/opt/appdata/wordpress/$id"
if [ -e "$file" ]
  then
    clear ## replace me
  else
    dialog --title "--- WARNING ---" --msgbox "\nCannot Backup WP Server! Local ID does not exist!" 0 0
  exit
fi
############################## If Exists on Google Drive
file="/mnt/gdrive/plexguide/backup/wordpress/$id"
if [ -e "$file" ]
  then
    clear ## replace me  
  else
    mkdir -p /mnt/gdrive/plexguide/backup/wordpress/$id/
fi
################################# PORT NUMBER

################################# SUBDOMAIN


ansible-playbook /opt/plexguide/ansible/wordpress.yml --tags restorewp
  read -n 1 -s -r -p "Press any key to continue"
