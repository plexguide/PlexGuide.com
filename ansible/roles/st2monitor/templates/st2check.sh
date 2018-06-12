#!/bin/bash
#
# [ST2 Monitor]
# Note:  This helps monitor if the log ever displays a failed status; rekick the 
# service back into play
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
#################################################################################
if pidof -o %PPID -x "$0"; then
   exit 1
fi

sleep 240
while true
do

systemctl status supertransfer2 3>&1 1>>/var/plexguide/st1.status 2>&1
tail -n2 /var/plexguide/st1.status &> /var/plexguide/st2.status

if grep -q Failed: "/var/plexguide/st2.status"; then
   systemctl restart supertransfer2
fi
sleep 20

dt=`date '+%d/%m/%Y %H:%M:%S'`
echo "$dt WARNING - SuperTransfer ST2 Upload Failed. Restarted Service" >> "/opt/appdata/plexguide/pg.log"

done



