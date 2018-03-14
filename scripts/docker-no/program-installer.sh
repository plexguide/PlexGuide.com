#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
clear
YMLPROGRAM=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLPORT=$(awk '/ymlport/{print $2}' /opt/plexguide/tmp.txt)


    docker stop "$YMLPROGRAM"
    docker rm "$YMLPROGRAM"
    docker-compose -f /opt/plexguide/scripts/docker/"$YMLPROGRAM".yml up -d
    echo
    echo Upgraded "$YMLDISPLAY" - Use Port "$YMLPORT" with IP Address; hostname -I;
    echo

bash /opt/plexguide/scripts/startup/owner.sh
read -n 1 -s -r -p "Press any key to continue "
echo ""
