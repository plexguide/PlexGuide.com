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
touch /var/plexguide/pg.clearner.stored
start=$( cat /var/plexguide/pg.clearner )
stored=$( cat /var/plexguide/pg.clearner.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  INSTALLING: PG Cleaner
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Deploys scripts in place to ensure to clean up files on parts of your
system!

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
sleep 5

# Execute Ansible Function
ansible-playbook /opt/plexguide/pg.yml --tags autodelete &>/dev/null &
ansible-playbook /opt/plexguide/pg.yml --tags clean &>/dev/null &
ansible-playbook /opt/plexguide/pg.yml --tags clean-encrypt &>/dev/null &

# Prevents From Repeating
cat /var/plexguide/pg.clearner > /var/plexguide/pg.clearner.stored

fi
