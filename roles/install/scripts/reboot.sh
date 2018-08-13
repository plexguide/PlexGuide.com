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
#################################################################################

test1=$(echo /var/plexguide/pg.preinstall)
test2=$(echo /var/plexguide/pg.preinstall.stored)
if [ "$test1" == "$test2" ]; then
      echo "" 1>/dev/null 2>&1
    else
      bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
fi
