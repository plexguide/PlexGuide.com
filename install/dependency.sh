#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
touch /var/plexguide/pg.dependency.stored
start=$( cat /var/plexguide/pg.dependency )
stored=$( cat /var/plexguide/pg.dependency.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  INSTALLING: Dependency Functions
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Functional programs install such as zip and unzip that ensures
plexguide works out of the box.

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
sleep 5

ospgversion=$(cat var/plexguide/os.version)
if [ "$ospgversion" == "debian" ]; then
  ansible-playbook /opt/plexguide/install/dependencydeb.yml;
else
  ansible-playbook /opt/plexguide/install/dependency.yml; fi

# Prevents From Repeating
cat /var/plexguide/pg.dependency > /var/plexguide/pg.dependency.stored

fi
