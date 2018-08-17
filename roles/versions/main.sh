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
program=$(cat /tmp/program_selection)
running=plexguide

while [ "$running" != "$program" ]; do
ansible-playbook /opt/plexguide/basics.yml --tags versions
running=$(cat /opt/plexguide/roles/versions/scripts/ver.list | grep $program -oP )

#if [ "$menu" == "update" ]; then
#  echo 'INFO - Selected: PG Upgrades Menu Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
#  bash /opt/plexguide/roles/versions/main.sh
#  exit
#fi

echo 'INFO - Looping: PG Application Suite Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting Application Suite Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
exit
