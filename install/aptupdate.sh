#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
touch /var/plexguide/pg.preinstall.stored
start=$( cat /var/plexguide/pg.preinstall )
stored=$( cat /var/plexguide/pg.preinstall.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  EXECUTING: General Update
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ensure that your system is updated for general use.

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
sleep 5

# Execute Ansible Function
yes | apt-get update
yes | apt-get install software-properties-common
yes | apt-get install sysstat nmon
sed -i 's/false/true/g' /etc/default/sysstat

# Prevents From Repeating
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored

fi
