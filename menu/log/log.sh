#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
dt=$(date '+%d/%m/%Y %H:%M:%S')
log=$(cat /var/plexguide/logs/pg.log)
echo "$dt $log" >>"/var/plexguide/logs/pg.log"
