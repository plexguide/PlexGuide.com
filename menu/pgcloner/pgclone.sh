#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgclone' > /var/plexguide/pgcloner.rolename
echo 'PG Clone' > /var/plexguide/pgcloner.roleproper
echo 'PlexGuide-PGClone' > /var/plexguide/pgcloner.projectname
echo 'v8.5' > /var/plexguide/pgcloner.projectversion
echo 'gdrive.sh' > /var/plexguide/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Clone utilizes RClone's Mounts + MergerFS's Union" > /var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/core/main.sh
