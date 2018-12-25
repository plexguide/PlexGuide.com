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
echo "dummy" > /var/plexguide/final.choice

#### Note How to Make It Select a Type - echo "removal" > /var/plexguide/type.choice
program=$(cat /var/plexguide/type.choice)

menu=$(echo "on")

while [ "$menu" != "break" ]; do
menu=$(cat /var/plexguide/final.choice)

### Loads Key Variables
bash /opt/plexguide/menu/interface/$program/var.sh
### Loads Key Execution
ansible-playbook /opt/plexguide/menu/core/selection.yml
### Executes Actions
bash /opt/plexguide/menu/interface/$program/file.sh

### Calls Variable Again - Incase of Break
menu=$(cat /var/plexguide/final.choice)

if [ "$menu" == "break" ];then
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: User Selected to Exit the Interface"
echo "---------------------------------------------------"
echo ""
sleep .5
fi

done
