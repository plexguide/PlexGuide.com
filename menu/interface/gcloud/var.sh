#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
echo 5 > /var/plexguide/menu.number

gcloud info | grep Account: | cut -c 10- > /var/plexguide/project.account

file="/var/plexguide/project.final"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "[NOT SET]" > /var/plexguide/project.final
  fi

file="/var/plexguide/project.keycount"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > /var/plexguide/project.keycount
  fi

### For PGBlitz - Ensure Not Deployed Start
  file="/var/plexguide/project.deployed"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "no" > /var/plexguide/project.deployed
    fi
