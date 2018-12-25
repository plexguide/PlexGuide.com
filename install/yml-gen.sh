#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

######################################################## Declare Variables
sname="YML Generation"

######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/menu/log/log.sh
######################################################## START: Main Script
ls -la /opt/plexguide/roles | awk '{ print $9 }' | tail -n +4 > /var/plexguide/yml.list
echo "INFO - YML List Generated @ /var/plexguide/yml.list" > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh

rm -rf /opt/plexguide/pg.yml 1>/dev/null 2>&1

echo "---" > /opt/plexguide/pg.yml
echo "- hosts: localhost" >> /opt/plexguide/pg.yml
echo "" >> /opt/plexguide/pg.yml
echo "  roles:" >> /opt/plexguide/pg.yml

while read p; do
  echo "  - { role: $p, tags: ['$p'] }" >> /opt/plexguide/pg.yml
done </var/plexguide/yml.list
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/menu/log/log.sh
