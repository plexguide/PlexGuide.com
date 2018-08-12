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
echo "on" > /var/plexguide/main.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/main.menu)
ansible-playbook /opt/plexguide/pg.yml --tags menu-start
menu=$(cat /var/plexguide/main.menu)

if [ "$menu" == "mount" ]; then
  echo 'INFO - Selected: Deploy a Mount System' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/deploychoice.sh
  clear
fi

if [ "$menu" == "traefik" ]; then
  echo 'INFO - Selected: Traefik & TLD' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/tld/scripts/submenu.sh
  clear
fi

if [ "$menu" == "cserverid" ]; then
  echo 'INFO - Selected: Change Server ID' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/backup-restore/server.sh
  clear
fi

if [ "$menu" == "rserverid" ]; then
  echo 'INFO - Selected: Change Server ID' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/backup-restore/recovery.sh
  clear
fi

done
