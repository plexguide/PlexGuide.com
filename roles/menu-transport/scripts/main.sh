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
echo "on" > /var/plexguide/transport.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/transport.menu)
ansible-playbook /opt/plexguide/roles/menu-transport/main.yml
menu=$(cat /var/plexguide/transport.menu)

if [ "$menu" == "blitzauto" ]; then
  echo 'INFO - Selected: Transport Blitz Auto' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-pgblitz/scripts/automated.sh
fi

if [ "$menu" == "move" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-move/scripts/main.sh
fi

if [ "$menu" == "blitzmanual" ]; then
  echo 'INFO - Selected: Transport Blitz Manual' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-pgblitz/scripts/manual.sh
fi

if [ "$menu" == "enmove" ]; then
  echo 'INFO - Selected: PG Move - PG Drive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-move-en/scripts/main.sh
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
