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
ansible-playbook /opt/plexguide/roles/menu-authenication/main.yml
menu=$(cat /var/plexguide/auth.menu)

if [ "$menu" == "appguard" ]; then
  echo 'INFO - Selected: AppGuard' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-transport/scripts/main.sh
fi

if [ "$menu" == "traefik" ]; then
  echo 'INFO - Selected: WIKD' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-tld/scripts/submenu.sh
fi

echo 'INFO - Looping: Main GDrive Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting PlexGuide' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/ending/ending.sh
