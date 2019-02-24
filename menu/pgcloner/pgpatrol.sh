#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgpatrol' > /var/plexguide/pgcloner.rolename
echo 'PGPatrol' > /var/plexguide/pgcloner.roleproper
echo 'PGPatrol' > /var/plexguide/pgcloner.projectname
echo 'v8.5' > /var/plexguide/pgcloner.projectversion
echo 'v8.5' > /var/plexguide/pgcloner.projectversion

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Patrol can boot idle plex users, users utilizing multiple
ips (sharing the server), and much more!" > /var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
