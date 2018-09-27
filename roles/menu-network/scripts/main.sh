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
echo "on" > /var/plexguide/network.menu
menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/network.menu)
ansible-playbook /opt/plexguide/roles/menu-network/main.yml
menu=$(cat /var/plexguide/network.menu)

if [ "$menu" == "basic" ]; then
  echo 'INFO - Selected: Simple Bench' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  sudo wget -qO- bench.sh | bash
  echo ""
  read -n 1 -s -r -p "Press [ANY] Key to Continue"
fi

if [ "$menu" == "advanced" ]; then
  echo 'INFO - Selected: Advanced Bench' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo ""
  curl -LsO raw.githubusercontent.com/Admin9705/plexguide-bench/master/bench.sh; chmod +x bench.sh; chmod +x bench.sh
  echo ""
  ./bench.sh -a
  echo ""
  read -n 1 -s -r -p "Press [ANY] Key to Continue"
fi

if [ "$menu" == "simple" ]; then
  echo 'INFO - Selected: Open Server Ports' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  pip install speedtest-cli
  echo ""
  speedtest-cli
  echo ""
  read -n 1 -s -r -p "Press [ANY] Key to Continue"
fi

if [ "$menu" == "container" ]; then
  echo 'INFO - Selected: Deployed SpeedTest Server Container' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  ansible-playbook /opt/plexguide/pg.yml --tags speedtest --extra-vars "quescheck=off cron=off display=on"
fi

echo 'INFO - Looping: Auditor Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Exiting: Transport System Select Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
