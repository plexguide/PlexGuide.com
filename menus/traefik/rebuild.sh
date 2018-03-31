#!/bin/bash
#
# [Rebuilding Containers]
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
dialog --title "Very Important" --msgbox "\nWe must rebuild each container occardingly! Please Be Patient!" 0 0
docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running
sed "traefik" < /opt/appdata/plexguide/running > /opt/appdata/plexguide/running
sed "watchtower" < /opt/appdata/plexguide/running > /opt/appdata/plexguide/running
while read p; do
  echo $p > /tmp/program_var
  app=$( cat /tmp/program_var )
  dialog --infobox "Reconsturcting Your Container: $app" 3 50
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags "$app" --skip-tags webtools,traefik 1>/dev/null 2>&1
  #read -n 1 -s -r -p "Press any key to continue "
done </opt/appdata/plexguide/running