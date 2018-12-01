#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

test1=$(echo /var/plexguide/pg.preinstall)
test2=$(echo /var/plexguide/pg.preinstall.stored)
if [ "$test1" == "$test2" ]; then
      echo "" 1>/dev/null 2>&1
    else
      bash /opt/plexguide/menu/scripts/containers/reboot.sh &>/dev/null &
fi
