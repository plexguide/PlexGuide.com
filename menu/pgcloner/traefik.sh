#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'traefik' > /var/plexguide/pgcloner.rolename
echo 'Traefik' > /var/plexguide/pgcloner.roleproper
echo 'PlexGuide-Traefik' > /var/plexguide/pgcloner.projectname
echo 'v8' > /var/plexguide/pgcloner.projectversion

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Clone is a combined group of services that utilizes PG Blitz and
PG Move in conjuction with RClone and automations to mount data drives
and transfer data in a hasty manner!" > /var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/core/main.sh
