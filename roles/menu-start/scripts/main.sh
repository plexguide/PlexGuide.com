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

if [ "$menu" == "programs" ]; then
  echo 'INFO - Selected: PG Program Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/programs/main.sh
  clear
fi

if [ "$menu" == "plextools" ]; then
  echo 'INFO - Selected: PLEX Enhancements' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/plex/enhancement.sh
  clear
fi

if [ "$menu" == "security" ]; then
  echo 'INFO - Selected: PG Security Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/security/main.sh
  clear
fi

if [ "$menu" == "info" ]; then
  echo 'INFO - Selected: PG Server Information' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/info-tshoot/info.sh
  clear
fi

if [ "$menu" == "tshoot" ]; then
  echo 'INFO - Selected: Info & Troubleshoot' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/info-tshoot/tshoot.sh
  clear
fi

if [ "$menu" == "backup" ]; then
  echo 'INFO - Selected: Backup & Restore' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/b-control/scripts/main.sh
  clear
fi

if [ "$menu" == "settings" ]; then
  echo 'INFO - Selected: Settings' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/settings/main.sh
  clear
fi

if [ "$menu" == "update" ]; then
  echo 'INFO - Selected: PG Upgrades Menu Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/version/main.sh
  exit
fi

echo 'INFO - Looping: Main GDrive Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting PlexGuide' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/ending/ending.sh
