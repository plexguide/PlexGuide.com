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

### START PROCESS
bash ./core/main.sh