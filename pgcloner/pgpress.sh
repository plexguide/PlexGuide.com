#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgpress' > /pg/var/pgcloner.rolename
echo 'PGPress' > /pg/var/pgcloner.roleproper
echo 'PGPress' > /pg/var/pgcloner.projectname
echo 'v90' > /pg/var/pgcloner.projectversion
echo 'pressmain.sh' > /pg/var/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PGPress is a combined group of services that enables the user to
deploy their own wordpress websites; including the use of other multiple
instances!" > /pg/var/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /pg/pgblitz/pgcloner/core/main.sh
