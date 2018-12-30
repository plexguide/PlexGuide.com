#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
touch /var/plexguide
if [[ $(docker ps | grep oauth) == "" ]]; then
  echo null > /var/plexguide/auth.var
else
  echo good > /var/plexguide/auth.var
fi
