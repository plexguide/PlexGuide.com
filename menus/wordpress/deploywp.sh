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
--inputbox "Type a Wordpress ID: " 8 50 2>/var/plexguide/wp.temp.id
id=$(cat /var/plexguide/wp.temp.id)

  if dialog --stdout --title "WP SERVER ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nWP SERVER ID: $id\n\nCorrect?" 0 0; then
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
clear ## change me
fi
############################## Ensure It Does Not EXIST DISTANT
file="/mnt/gdrive/plexguide/backup/XXXXX/wordpress/$id"
if [ -e "$file" ]
  then
clear ## change me
fi
################################# PORT NUMBER

################################# SUBDOMAIN

  dialog --title "[ EXAMPLE: nzbgetwp or pgwordpress ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Enter a SUBDOMAIN for Your Website" 8 50 2>/var/plexguide/subdomain.temp.id
  subdomain=$(cat /var/plexguide/subdomain.temp.id)

  if dialog --stdout --title "SUBDOMAIN" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nYour Subdomain: $subdomain\n\nCorrect?" 0 0; then

    ### Ensure Location Get Stored for Variables Role
    echo "$subdomain" > /var/plexguide/wpsubdomain.id
  else
    dialog --title "SUBDOMAIN" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/backup-restore/first.sh
      exit
  fi

  dialog --title "[ EXAMPLE: 101 or 989 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Enter 3 Numbers Between 100-999" 8 50 2>/var/plexguide/port.temp.id
  port=$(cat /var/plexguide/port.temp.id)

  if dialog --stdout --title "SERVER ID" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nThree Numbers Entered: $port\n\nCorrect?" 0 0; then

    ### Ensure Location Get Stored for Variables Role
    echo "$port" > /var/plexguide/wpport.id
  else
    dialog --title "Server ID Choice" --msgbox "\nSelected - Not Correct - Rerunning!" 0 0
      bash /opt/plexguide/menus/backup-restore/first.sh
      exit
  fi

if [ "$port" -ge 100 -a "$port" -le 999 ]; then
  clear ## change me
else
    read -n 1 -s -r -p "Press any key to continue - Bad"
  dialog --title "Server ID Choice" --msgbox "\nYou Failed to Enter a Value between 100-999!\n\nExiting!" 0 0
exit
fi

  clear
  ansible-playbook /opt/plexguide/ansible/wordpress.yml --tags wordpress
  read -n 1 -s -r -p "Press any key to continue"
