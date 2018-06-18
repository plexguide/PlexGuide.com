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
  dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, and I am Ready!\n\nThis you named and can access your HD! If you botch the name, visit SETTINGS and change ANYTIME!" 0 0
  echo "yes" > /var/plexguide/server.hd
  base="/mnt/gdrive/plexguide/backup/"

  dialog --title "INPUT NEW RECOVERY ID[ EXAMPLE: 06182018 or ALPHA5 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Full Path: " 8 50 2>/var/plexguide/recovery.temp.id
  id=$(cat /var/plexguide/recovery.temp.id)

  if dialog --stdout --title "SERVER RECOVERY ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nPATH: $id\n\nCorrect?" 0 0; then
    dialog --title "--- NOTE ---" --msgbox "\nRecovery ID: $id\n\nTracking!" 0 0
    
    ##### READ / WRITE CHECK
    mkdir "$base$id/plexguide"
    
    file="$base$id/plexguide"
    if [ -e "$file" ]
      then
        dialog --title "PG Path Checker" --msgbox "\nPATH: $id\n\The ID Exists! Changing Your Recovery ID!" 0 0
        rm -r "$id/plexguide"
      else
        dialog --title "PG Path Checker" --msgbox "\nPATH: $id\n\nThis Recovery ID does not EXIST! Check Your Google Drive!" 0 0
        #bash /opt/plexguide/scripts/baseinstall/harddrive.sh
        exit
    fi

    ### Ensure Location Get Stored for Variables Role
    echo "$id" > /var/plexguide/restore.id

    dialog --title "PG Container Status" --msgbox "\nContainers Rebuilt According to Your Path!\n\nWant to check? Use PORTAINER and check the ENVs of certain containers!" 0 0
    exit

  else
    dialog --title "Recovery ID Choice" --msgbox "\nSelected Not Correct. Re-running Backup/Recovery Menu!" 0 0
    #bash /opt/plexguide/scripts/baseinstall/harddrive.sh
    #exit
  fi

esac