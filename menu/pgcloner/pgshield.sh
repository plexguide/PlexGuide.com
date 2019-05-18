#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgshield' > /pg/var/pgcloner.rolename
echo 'PGShield' > /pg/var/pgcloner.roleproper
echo 'PGShield' > /pg/var/pgcloner.projectname
echo 'v8.6' > /pg/var/pgcloner.projectversion
echo 'pgshield.sh' > /pg/var/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Shield protects users by deploying adding Google
Authentication to all the containers for protection!" > /pg/var/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
