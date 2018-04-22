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
dialog --title "Very Important" --msgbox "\nWe must rebuild CERTAIN containers occardingly! Please Be Patient!" 0 0
docker ps -a --format "{{.Names}}" > /opt/appdata/plexguide/running
sed -i -e "/traefik/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/watchtower/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/plex/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/portainer/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/traefik/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/ombi/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/ombi4k/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/organizr/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/muximux/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/support/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/tautulli/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/telly/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
sed -i -e "/couchpotato/d" /opt/appdata/plexguide/running 1>/dev/null 2>&1
while read p; do
echo $p > /tmp/program_var
app=$( cat /tmp/program_var )
dialog --infobox "Reconstructing Your Container: $app" 3 50
ansible-role "$app" 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "
done </opt/appdata/plexguide/running