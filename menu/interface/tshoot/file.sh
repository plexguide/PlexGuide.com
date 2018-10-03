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
menu=$(cat /var/plexguide/final.choice)

if [ "$menu" == "2" ]; then
  bash /opt/plexguide/scripts/baseinstall/harddrive.sh
fi

if [ "$menu" == "3" ]; then
  bash /opt/plexguide/roles/processor/scripts/processor-menu.sh
fi

if [ "$menu" == "4" ]; then
  bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
fi

if [ "$menu" == "5" ]; then
  bash /opt/plexguide/roles/watchtower/menus/main.sh
fi
