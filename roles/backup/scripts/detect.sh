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
ls -la /opt/appdata | awk '{ print $9}' | tail -n 9 > /tmp/local.list

while read list; do
  echo $list > /tmp/local.current

grep

clear
app=$( cat /tmp/program_var )
if [ "$app" == "plex" ]
  then
    ### IF PLEX, execute this
    ansible-playbook /opt/plexguide/pg.yml --tags backup_normal,backup_plex
else
    ### IF NOT PLEX, execute this
    ansible-playbook /opt/plexguide/pg.yml --tags backup_normal,backup_other
fi
done </tmp/local.list
