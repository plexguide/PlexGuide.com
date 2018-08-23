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
echo "on" > /var/plexguide/ports.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/ports.menu)
ansible-playbook /opt/plexguide/roles/menu-ports/main.yml
menu=$(cat /var/plexguide/ports.menu)

if [ "$menu" == "open" ]; then
  echo "" > /var/plexguide/server.ports
  echo 'INFO - Selected: Open Server Ports' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-ports/scripts/rebuild.sh
fi

if [ "$menu" == "closed" ]; then
  echo "127.0.0.1:" > /var/plexguide/server.ports
  echo 'INFO - Selected: Closed Server Ports' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-ports/scripts/rebuild.sh
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
