#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
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

#rm -r /opt/appdata/plexdrive.info 1>/dev/null 2>&1
#touch /opt/appdata/plexdrive.info 1>/dev/null 2>&1
PD="Blank"

while [ "$PD" != "Opening" ]; do
sleep 3
#systemctl status plexdrive >> /opt/appdata/plexguide/plexdrive.info
PD=$(grep -o Opening /opt/appdata/plexguide/plexdrive.info | head -1)
done

rm -r /opt/appdata/plexdrive.info 1>/dev/null 2>&1
clear
echo "PlexDrive4 Finished Scanning - Rebooting Your System"
sudo reboot