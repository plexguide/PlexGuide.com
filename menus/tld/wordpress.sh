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
base="/mnt/gdrive/plexguide/wordpress/"

dialog --title "[ EXAMPLE: plexguide or mysubdomain ]" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "The Subdomain/ID Wanted for the Top Level Domain: " 8 50 2>/var/plexguide/wp.temp.id
id=$(cat /var/plexguide/wp.temp.id)

  if dialog --stdout --title "Top Level Domain Selection" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nWP Subdomain/ID: $id\n\nCorrect?" 0 0; then
    ### Ensure Location Get Stored for Variables Role
    echo "$id" > /var/plexguide/wp.id
  else
    dialog --title "WP Subdomain/ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/wordpress/main.sh
      exit
  fi

############################## Ensure It Does Not EXIST LOCAL
file="/opt/appdata/wordpress/$id"
if [ -e "$file" ]
  then
    clear ## replace me
  else
    dialog --title "--- WARNING ---" --msgbox "\nCannot Execute! Local Subdomain-ID does not exist!" 0 0
  exit
fi