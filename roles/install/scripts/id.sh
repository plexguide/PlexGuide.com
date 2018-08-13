#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
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

######################################################## Declare Variables
sname="PG Installer: Server ID"
pg_id=$( cat /var/plexguide/pg.id )
pg_id_stored=$( cat /var/plexguide/pg.id.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
if [ "$pg_id" == "$pg_id_stored" ]; then
      echo "" 1>/dev/null 2>&1
    else
      dialog --infobox "Installing | Upgrading Server IDs" 3 50
      sleep 2
      clear

      file="/var/plexguide/server.id"
        if [ -e "$file" ]; then
          echo "" 1>/dev/null 2>&1
        else
          echo "INFO - First Time: Server ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

          dialog --title "--- INFO ---" --msgbox "\nYou Are Creating a SERVER ID for Identification/Backup Purposes!\n\nRemember KISS (Keep It Simple Stupid) for your ID!" 0 0

          dialog --title "[ EXAMPLE: SERVER01 or PG9705 ]" \
          --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
          --inputbox "Type Your Server ID: " 8 50 2>/var/plexguide/server.temp.id
          id=$(cat /var/plexguide/server.temp.id)

          if dialog --stdout --title "SERVER ID" \
              --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
              --yesno "\nSERVER ID: $id\n\nCorrect?" 0 0; then

              dialog --title "--- SERVER ID ---" --msgbox "\nSERVER ID: $id\n\nIS SET!" 0 0
              ### Ensure Location Get Stored for Variables Role
              echo "$id" > /var/plexguide/server.id
              cat /var/plexguide/pg.id > /var/plexguide/pg.id.stored

              ### Create Recovery ID if it Does Not Exist
              file="/var/plexguide/restore.id"
                if [ -e "$file" ]
                  then
                    echo "" 1>/dev/null 2>&1
                  else
                    cat /var/plexguide/server.id > /var/plexguide/restore.id
                    echo "INFO - First Time: Restore ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                fi
          else
              dialog --title "Server ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
              bash /opt/plexguide/roles/install/scripts/id.sh
              exit
          fi
     fi
fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
