#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgpatrol' > /pg/var/pgcloner.rolename
echo 'PGPatrol' > /pg/var/pgcloner.roleproper
echo 'PGPatrol' > /pg/var/pgcloner.projectname
echo 'v8.6' > /pg/var/pgcloner.projectversion

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Patrol can boot idle plex users, users utilizing multiple
ips (sharing the server), and much more!" > /pg/var/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /pg/pgblitz/menu/pgcloner/corev2/main.sh
