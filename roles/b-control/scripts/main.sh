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
echo "on" > /var/plexguide/br.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/br.menu)
ansible-playbook /opt/plexguide/pg.yml --tags b-control
menu=$(cat /var/plexguide/br.menu)

if [ "$menu" == "mbackup" ]; then
  bash /opt/plexguide/roles/b-mbackup/scripts/bmass.sh
fi

if [ "$menu" == "mrestore" ]; then
  bash /opt/plexguide/roles/b-mrestore/scripts/rmass.sh
fi

if [ "$menu" == "cserverid" ]; then
  echo 'INFO - Selected: Change Server ID' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/backup-restore/server.sh
fi

done
