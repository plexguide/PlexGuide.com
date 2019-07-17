#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq - Sub7Seven
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
echo 2 >/var/plexguide/menu.number

file="/var/plexguide/server.id"
if [ ! -e "$file" ]; then
  echo NOT-SET >/var/plexguide/server.id
fi
