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
echo "on" > /var/plexguide/tldsub.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/tldsub.menu)
ansible-playbook /opt/plexguide/roles/menu-tld/selection.yml
menu=$(cat /var/plexguide/tldsub.menu)

if [ "$menu" == "traefik" ]; then
  echo 'INFO - Selected: PG Traefik - Reverse Proxy' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  touch /var/plexguide/traefik.lock
  ansible-playbook /opt/plexguide/pg.yml --tags traefik
  file="/var/plexguide/traefik.lock"
  if [ -e "$file" ]; then
    echo "" && read -n 1 -s -r -p "Did Not Complete Deployment! Press [ANY] Key to EXIT!"
  else
    echo "" && read -n 1 -s -r -p "We Must Rebuild Your Containers! Press [ANY] Key!"
    bash /opt/plexguide/roles/traefik/scripts/rebuild.sh
    echo "" && read -n 1 -s -r -p "Containers Rebuilt! Press [ANY] Key to Continue!"
  fi
fi

if [ "$menu" == "tld" ]; then
  echo 'INFO - Selected: TLD Application' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "off" > /var/plexguide/tld.control
  ansible-playbook /opt/plexguide/pg.yml --tags menu-tld
  control=$(cat /var/plexguide/tld.control)
  if [ "$control" == "on" ]; then
    bash /opt/plexguide/roles/menu-tld/scripts/rebuild.sh
  else
    sleep 0.5
    echo "" && read -n 1 -s -r -p "User Exited! - Press [Any] Key to Continue"
  fi
fi

if [ "$menu" == "cf" ]; then
  echo 'INFO - Selected: CF Automatic Domain Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/programs/core/cf/file.sh
fi

echo 'INFO - Looping: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
