#!/bin/bash
#
# [Ansible Role]
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
echo "on" > /var/plexguide/auth.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/auth.menu)
  ansible-playbook /opt/plexguide/pg.yml --tags menu-authenication
menu=$(cat /var/plexguide/auth.menu)

if [ "$menu" == "appguard" ]; then
  echo 'INFO - Selected: AppGuard Authentication' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-appguard/scripts/main.sh
fi

file2="/var/plexguide/auth.lock"
if [ -e "$file2" ]; then
  rm -r /var/plexguide/auth.lock
  bash /opt/plexguide/roles/menu-authenication/scripts/rebuild.sh
fi

echo 'INFO - Looping: PG Authentication Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting Authenticator' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
