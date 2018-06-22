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
dialog --title "--- INFO ---" --msgbox "\nYou Are Creating a UNIQUE Wordpress ID!\n\nRemember KISS (Keep It Simple Stupid)!" 0 0

#######################
echo "yes" > /var/plexguide/server.wp
base="/mnt/gdrive/plexguide/wordpress/"

dialog --title "[ EXAMPLE: SERVER01 or plexguide.com ]" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Type a Wordpress ID: " 8 50 2>/var/plexguide/recovery.temp.id
id=$(cat /var/plexguide/wp.temp.id)


  if dialog --stdout --title "SERVER ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nSERVER ID: $id\n\nCorrect?" 0 0; then

    dialog --title "--- SERVER ID ---" --msgbox "\nWP ID: $id\n\nIS SET!" 0 0
    ### Ensure Location Get Stored for Variables Role
    echo "$id" > /var/plexguide/server.id
  else
    dialog --title "Server ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/backup-restore/first.sh
      exit
  fi

############################## Ensure It Does Not EXIST LOCAL
file="/opt/appdata/wordpress/$id"
if [ -e "$file" ]
  then
clear
fi
############################## Ensure It Does Not EXIST DISTANT
file="/mnt/gdrive/plexguide/backup/XXXXX/wordpress/$id"
if [ -e "$file" ]
  then
clear
fi
################################# PORT NUMBER

  dialog --title "[ No More Than 3 Numbers! EXAMPLE: 005 or 989 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Port 9:" 8 50 2>/var/plexguide/port.temp.id
  port=$(cat /var/plexguide/port.temp.id)

  if dialog --stdout --title "SERVER ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nSERVER ID: $id\n\nCorrect?" 0 0; then

    dialog --title "--- SERVER ID ---" --msgbox "\nSERVER ID: $id\n\nIS SET!" 0 0
    ### Ensure Location Get Stored for Variables Role
    echo "$port" > /var/plexguide/wpport.id
  else
    dialog --title "Server ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/backup-restore/first.sh
      exit
  fi

  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress