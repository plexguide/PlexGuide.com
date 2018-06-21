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
dialog --title "--- INFO ---" --msgbox "\nEnsure you create a NEW UNIQUE ID!" 0 0
echo "yes" > /var/plexguide/server.wp
base="/mnt/gdrive/plexguide/wordpress/"

dialog --title "[ EXAMPLE: SERVER01 or plexguide.com ]" \
--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
--inputbox "Type a Wordpress ID: " 8 50 2>/var/plexguide/recovery.temp.id
id=$(cat /var/plexguide/wp.temp.id)

############################## Ensure It Does Not EXIST LOCAL
file="/opt/appdata/wordpress/$id"
if [ -e "$file" ]
  then
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress
    exit
fi

############################## Ensure It Does Not EXIST DISTANT
file="/mnt/gdrive/plexguide/backup/XXXXX/wordpress/$id"
if [ -e "$file" ]
  then
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress
    exit
fi

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress

#### PUT A NOTE HERE TO END