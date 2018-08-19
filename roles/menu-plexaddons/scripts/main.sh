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
clear
echo "on" > /var/plexguide/plexaddons.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/plexaddons.menu)
ansible-playbook /opt/plexguide/basics.yml --tags menu-transport
menu=$(cat /var/plexguide/plexaddons.menu)

if [ "$menu" == "webtools" ]; then
  echo 'INFO - Selected: Plex WebTools' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/pg.yml --tags webtools
fi

if [ "$menu" == "pgtrak" ]; then
  echo 'INFO - Selected: PGTrak' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/pgtrak/main.sh
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/ending/ending.sh
