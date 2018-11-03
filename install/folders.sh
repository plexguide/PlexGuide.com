#!/usr/bin/env python3
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
touch /var/plexguide/pg.dependency.stored
start=$( cat /var/plexguide/pg.dependency )
stored=$( cat /var/plexguide/pg.dependency.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ⌛ INSTALLING: Dependency Functions                                 ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                                                     ┃
┃ Functional programs install such as zip and unzip that ensures      ┃
┃ plexguide works out of the box.                                     ┃
┃                                                                     ┃
┃ PLEASE STANDBY!                                                     ┃
┃                                                                     ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF

# Standby
sleep 5

# Execute Ansible Function
ansible-playbook /opt/plexguide/pg.yml --tags dependency

# Prevents From Repeating
cat /var/plexguide/pg.dependency > /var/plexguide/pg.dependency.stored

fi
