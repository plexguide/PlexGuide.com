#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
dt=`date '+%d/%m/%Y %H:%M:%S'`
log=$( cat /var/plexguide/pg.log )
echo "$dt $log" >> "/opt/appdata/plexguide/pg.log"
