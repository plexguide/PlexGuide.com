#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'traefik' >/var/plexguide/pgcloner.rolename
echo 'Traefik' >/var/plexguide/pgcloner.roleproper
echo 'Traefik' >/var/plexguide/pgcloner.projectname
echo 'v8.6' >/var/plexguide/pgcloner.projectversion
echo 'traefik.sh' >/var/plexguide/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 Traefik is a modern HTTP reverse proxy and load balancer that makes
deploying microservices easy. It serves as a reverse proxy that enables a
user to mass obtain https (secure) certificates for all their containers" >/var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
