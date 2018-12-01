#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

######################################################## Declare Variables
sname="Docker Start Assist"
pg_docstart=$( cat /var/plexguide/pg.docstart )
pg_docstart_stored=$( cat /var/plexguide/pg.docstart.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
if [ "$pg_docstart" == "$pg_docstart_stored" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "Installing PG Docker Startup Assist" > /var/plexguide/message.phase
      bash /opt/plexguide/menu/interface/install/scripts/message.sh
      ansible-playbook /opt/plexguide/pg.yml --tags docstart
      cat /var/plexguide/pg.docstart > /var/plexguide/pg.docstart.stored
  fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
