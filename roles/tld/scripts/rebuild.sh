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
count=$(wc -l < /tmp/backup.list)
((count++))
((count--))

for ((i=1; i<$count+1; i++)); do
	app=$(sed "${i}q;d" /tmp/backup.list)
	ansible-playbook /opt/plexguide/pg.yml --tags $app
done
echo ""
read -n 1 -s -r -p "Containers - Rebuilt! Press [Any] Key to Continue"
echo 'INFO - Rebuilding Complete!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
