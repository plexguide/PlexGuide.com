#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgui' >/var/plexguide/pgcloner.rolename
echo 'UI' >/var/plexguide/pgcloner.roleproper
echo 'BlitzUI' >/var/plexguide/pgcloner.projectname
echo 'v8.6' >/var/plexguide/pgcloner.projectversion

### START PROCESS
ansible-playbook /opt/plexguide/menu/pgcloner/core/primary.yml
