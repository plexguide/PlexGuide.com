#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
sleep 15

while true
do

# GDrive
if [[ $(rclone lsd --config /opt/appdata/plexguide/rclone.conf gdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "Not Operational"> pg.gdrive; else echo "Operational" > pg.gdrive; fi

if [[ $(rclone lsd --config /opt/appdata/plexguide/rclone.conf tdrive: | grep "\<plexguide\>") == "" ]]; then
  echo "Not Operational"> pg.tdrive; else echo "Operational" > pg.tdrive; fi

sleep 10
done
