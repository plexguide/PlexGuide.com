#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
touch /var/plexguide/pg.cleaner.stored
start=$( cat /var/plexguide/pg.cleaner )
stored=$( cat /var/plexguide/pg.cleaner.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  INSTALLING: PG Cleaner
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Deploys scripts in place to ensure to clean up files on parts of your
system!

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
sleep 3

# Execute Ansible Function
ansible-playbook /opt/plexguide/menu/pg.yml --tags autodelete &>/dev/null &
ansible-playbook /opt/plexguide/menu/pg.yml --tags clean &>/dev/null &
ansible-playbook /opt/plexguide/menu/pg.yml --tags clean-encrypt &>/dev/null &

# Prevents From Repeating
cat /var/plexguide/pg.cleaner > /var/plexguide/pg.cleaner.stored

fi
