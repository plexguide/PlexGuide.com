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
old=$(cat /var/plexguide/old.tld) 1>/dev/null 2>&1
new=$(cat /var/plexguide/tld.program) 1>/dev/null 2>&1

echo ""
read -n 1 -s -r -p "Only the Old TLD & New TLD Containers Must Be Rebuilt!\nPress [Any] Key to Continue"
echo ""

ansible-playbook /opt/plexguide/pg.yml --tags $old --extra-vars "quescheck=on cron=off display=off"
ansible-playbook /opt/plexguide/pg.yml --tags $new --extra-vars "quescheck=on cron=off display=off"

read -n 1 -s -r -p "Containers - Rebuilt! Press [Any] Key to Continue"
echo 'INFO - Rebuilding Complete!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
