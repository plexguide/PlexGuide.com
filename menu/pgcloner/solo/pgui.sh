#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgui' > /var/plexguide/pgcloner.rolename
echo 'UI' > /var/plexguide/pgcloner.roleproper
echo 'PlexGuide-UI' > /var/plexguide/pgcloner.projectname
echo 'v8.4' > /var/plexguide/pgcloner.projectversion

### START PROCESS
bash /opt/plexguide/menu/pgcloner/core/main.sh
