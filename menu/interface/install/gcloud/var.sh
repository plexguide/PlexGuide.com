#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
