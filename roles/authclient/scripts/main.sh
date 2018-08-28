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
echo "on" > /var/plexguide/authclient.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/authclient.menu)
ansible-playbook /opt/plexguide/pg.yml --tags authclient
menu=$(cat /var/plexguide/authclient.menu)

if [ "$menu" == "appguard" ]; then
  echo 'INFO - Selected: AppGuard Authentication' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/pg.yml --roles menu-appguard
fi

if [ "$menu" == "wckd" ]; then
  echo 'INFO - Selected: WCKD Authentication' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/pg.yml --roles authclient
fi

echo 'INFO - Looping: PG Authentication Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting PlexGuide' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/ending/ending.sh
