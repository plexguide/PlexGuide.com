#!/bin/bash
#
# Title:      PGBlitz (local used space)
# Author(s):  Admin9705
# Coder: 	    MrDoob
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
while [ 1 ]; do

 rm -rf /var/plexguide/spaceused.log
 rm -rf /var/plexguide/trafficused.log
 rm -rf /var/plexguide/incomplete-used.log

	 du -sh /mnt/move | awk '{print $1}' >> /var/plexguide/spaceused.log
	 du -sh /mnt/downloads | awk '{print $1}' >> /var/plexguide/spaceused.log

echo "Used Traffic | last 3 days"  >> /var/plexguide/trafficused.log
         
         vnstat -d | tail -n 5 | head -n 3 >> /var/plexguide/trafficused.log
#used space of incomplete        
         du -sh /mnt/incomplete | awk '{print $1}' >> /var/plexguide/incomplete-used.log

sleep 30

done
