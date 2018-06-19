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
  dialog --title "--- INFO ---" --msgbox "\nYou Are Creating a SERVER ID for Identification/Backup Purposes!\n\nRemember KISS (Keep It Simple Stupid) for your ID!" 0 0

  dialog --title "[ EXAMPLE: SERVER01 or PG9705 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Type Your Server ID: " 8 50 2>/var/plexguide/server.temp.id
  id=$(cat /var/plexguide/server.temp.id)

  if dialog --stdout --title "SERVER ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nRECOVERY ID: $id\n\nCorrect?" 0 0; then

    dialog --title "--- SERVER ID ---" --msgbox "\nID: $id\n\nSERVER ID: $id\n\nIS SET!" 0 0
    ### Ensure Location Get Stored for Variables Role
    echo "$id" > /var/plexguide/server.id

  else
    dialog --title "Server ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/backup-restore/first.sh
      exit
  fi