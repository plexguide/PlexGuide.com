#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'hcloud' > /var/plexguide/pgcloner.rolename
echo 'HCloud (Hetzner)' > /var/plexguide/pgcloner.roleproper
echo 'Hetzner' > /var/plexguide/pgcloner.projectname
echo 'v8.5' > /var/plexguide/pgcloner.projectversion
echo 'hcloud' > /var/plexguide/pgcloner.projectversion

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 HCloud in conjuction with PlexGuide enables users to
deploy Hetzner Cloud Instance (VMs) within seconds" > /var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
