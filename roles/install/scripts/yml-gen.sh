#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
################################################################################

######################################################## Declare Variables
sname="YML Generation"

######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
ls -la /opt/plexguide/roles | awk '{ print $9 }' | tail -n +4 > /var/plexguide/yml.list
echo "INFO - YML List Generated @ /var/plexguide/yml.list" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

rm -r /opt/plexguide/pg.yml 1>/dev/null 2>&1

echo "---" > /opt/plexguide/pg.yml
echo "- hosts: localhost" >> /opt/plexguide/pg.yml
cat /opt/plexguide/roles/global_vars.sh >> /opt/plexguide/pg.yml
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
sudo bash /opt/plexguide/roles/log/log.sh
