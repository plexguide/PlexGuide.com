#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'hetzner' > /pg/var/pgcloner.rolename
echo 'HCloud (Hetzner)' > /pg/var/pgcloner.roleproper
echo 'Hetzner' > /pg/var/pgcloner.projectname
echo 'v8.6' > /pg/var/pgcloner.projectversion
echo 'hcloud.sh' > /pg/var/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 HCloud in conjuction with PGBlitz enables users to
deploy Hetzner Cloud Instance (VMs) within seconds" > /pg/var/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
