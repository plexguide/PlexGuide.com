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
echo "on" > /var/plexguide/main.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/main.menu)
ansible-playbook /opt/plexguide/roles/menu-start/main.yml
menu=$(cat /var/plexguide/main.menu)

if [ "$menu" == "mount" ]; then
  echo 'INFO - Selected: Deploy a Mount System' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  edition=$(cat /var/plexguide/pg.edition.stored)
  if [ "$edition" == "PG Edition - HD Solo" ]; then
    echo ""
    echo "Utilizing the HD Solo Edition! Cannot Setup HDs!"
    echo "Note: Data Stored via the Solo HD @ /mnt"
    echo ""
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/roles/menu-transport/scripts/main.sh
  fi

fi

if [ "$menu" == "traefik" ]; then
  echo 'INFO - Selected: Traefik & TLD' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-tld/scripts/submenu.sh
fi

if [ "$menu" == "programs" ]; then
  echo 'INFO - Selected: PG Program Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/programs/main.sh
fi

if [ "$menu" == "plextools" ]; then
  echo 'INFO - Selected: PLEX Enhancements' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-plexaddons/scripts/main.sh
fi

if [ "$menu" == "security" ]; then
  echo 'INFO - Selected: PG Security Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/security/main.sh
fi

if [ "$menu" == "tshoot" ]; then
  echo 'INFO - Selected: PG Server Information' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/info-tshoot/tshoot.sh
fi

if [ "$menu" == "auditor" ]; then
  echo 'INFO - Selected: Auditor' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-network/scripts/main.sh
fi

if [ "$menu" == "backup" ]; then
  echo 'INFO - Selected: Backup & Restore' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/b-control/scripts/main.sh
fi

if [ "$menu" == "settings" ]; then
  echo 'INFO - Selected: Settings' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/settings/main.sh
fi

if [ "$menu" == "auth" ]; then
  echo 'INFO - Selected: Authentication Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-authenication/scripts/main.sh
fi

if [ "$menu" == "wckd" ]; then
  echo 'INFO - Selected: WCKD Authentication' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/pg.yml --tags authclient --extra-vars "quescheck=on cron=off display=on"
fi

if [ "$menu" == "ports" ]; then
  echo 'INFO - Selected: Ports Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-ports/scripts/main.sh
fi

echo 'INFO - Looping: Main GDrive Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting PlexGuide' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/ending/ending.sh
