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
  dialog --title "--- INFO ---" --msgbox "\nThe RECOVERY ID is the TARGET SERVER you have on GDRIVE!" 0 0
  echo "yes" > /var/plexguide/server.hd
  base="/mnt/gdrive/plexguide/backup/"

  dialog --title "[ EXAMPLE: SERVER01 or PG9705 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Type Your Recovery ID: " 8 50 2>/var/plexguide/recovery.temp.id
  id=$(cat /var/plexguide/recovery.temp.id)

  if dialog --stdout --title "SERVER RECOVERY ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nRECOVERY ID: $id\n\nCorrect?" 0 0; then

    ##### READ / WRITE CHECK
    mkdir "$base$id/plexguide" 1>/dev/null 2>&1
    
    file="$base$id/plexguide"
    if [ -e "$file" ]
      then
        dialog --title "--- Checker ---" --msgbox "\nID: $id\n\nThat Recovery ID Exists!" 0 0
        rm -r "$base$id/plexguide" 1>/dev/null 2>&1
      else
        dialog --title "--- Checker ---" --msgbox "\nID: $id\n\nThat Recovery ID does not EXIST! Check Your Google Drive!" 0 0
        #bash /opt/plexguide/scripts/baseinstall/harddrive.sh
        exit
    fi

    ### Ensure Location Get Stored for Variables Role
    echo "$id" > /var/plexguide/restore.id

  else
    dialog --title "Recovery ID Choice" --msgbox "\nSelected - Not Correct - Rerunning Backup/Recovery Menu!" 0 0
    #bash /opt/plexguide/scripts/baseinstall/harddrive.sh
    #exit
  fi

esac