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
docker logs --tail 1 traefik2 2> /var/plexguide/status.traefik2
dock=$( cat /var/plexguide/status.traefik2 )
dock=${dock#*responded with a} 
dock=${dock::-1}
echo $dock | head -c 1
echo $dock > /var/plexguide/status.traefik2

echo $dock 
dock2=$( cat /var/plexguide/status.traefik2 )
if [ "$dock2" == "certificate" ]
then
echo "$dock2"
echo "$bite
fi