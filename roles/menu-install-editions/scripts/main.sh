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
echo "on" > /var/plexguide/pgeditions.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/pgeditions.menu)
ansible-playbook /opt/plexguide/pg.yml --tags menu-install-editions
menu=$(cat /var/plexguide/pgeditions.menu)

if [ "$menu" == "gdrive" ]; then
  echo 'INFO - Selected PG Edition: GDrive' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "PG Edition - GDrive" > /var/plexguide/pg.edition
  echo "gdrive" > /var/plexguide/pg.server.deploy
  cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
  exit
fi

if [ "$menu" == "solohd" ]; then
  echo 'INFO - Selected PG Edition: HD Solo' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/pg.yml --tags folders_solo &>/dev/null &
  echo "PG Edition - HD Solo" > /var/plexguide/pg.edition
  echo "drive" > /var/plexguide/pg.server.deploy
  cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
  exit
fi

if [ "$menu" == "multihd" ]; then
  echo 'INFO - Select PG Edition: HD Multi' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "PG Edition - HD Multi" > /var/plexguide/pg.edition
  echo "drives" > /var/plexguide/pg.server.deploy
  cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
  exit
fi

if [ "$menu" == "gce" ]; then
  echo 'INFO - Select PG Edition: GCE Feeder' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "PG Edition - GCE Feed" > /var/plexguide/pg.edition
  echo "feeder" > /var/plexguide/pg.server.deploy
  cat /var/plexguide/pg.edition > /var/plexguide/pg.edition.stored
  exit
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done
