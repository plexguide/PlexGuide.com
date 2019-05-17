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

	 du -sh /mnt/downloads | awk '{print $1}' >> /var/plexguide/spaceused.log
	 du -sh /mnt/move | awk '{print $1}' >> /var/plexguide/spaceused.log

sleep 30

done
