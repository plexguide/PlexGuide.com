#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgshield' >/var/plexguide/pgcloner.rolename
echo 'PGShield' >/var/plexguide/pgcloner.roleproper
echo 'PGShield' >/var/plexguide/pgcloner.projectname
echo 'v8.6' >/var/plexguide/pgcloner.projectversion
echo 'pgshield.sh' >/var/plexguide/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Shield protects users by deploying adding Google
Authentication to all the containers for protection!" >/var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
