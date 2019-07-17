#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### FILL OUT THIS AREA ###
echo 'pgvault' >/var/plexguide/pgcloner.rolename
echo 'PG Vault' >/var/plexguide/pgcloner.roleproper
echo 'PGVault' >/var/plexguide/pgcloner.projectname
echo 'v8.6' >/var/plexguide/pgcloner.projectversion
echo 'pgvault.sh' >/var/plexguide/pgcloner.startlink

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "💬 PG Vault is a combined group of services that utilizes the backup
and restore processes, which enables the safe storage and transport through
the use of Google Drive in a hasty and efficient manner!" >/var/plexguide/pgcloner.info
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### START PROCESS
bash /opt/plexguide/menu/pgcloner/corev2/main.sh
