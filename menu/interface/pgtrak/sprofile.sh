#!/bin/bash
#
# [Ansible Role]
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
tee <<-EOF

---------------------------------------------------------------------------
Sonarr Profile
---------------------------------------------------------------------------

NOTE: Set a profile for Sonarr to Set! Type a profile that exists! You can
add/set profiles to Sonarr and can use them here also!

WARNING: Failing to type a profile that DOES NOT EXIST equals FAILURE!

Default Profiles for Sonarr (case senstive):

Any
SD
HD-720p
HD-1080p
Ultra-HD
HD - 720p/1080p

EOF
read -p 'Type a Sonarr Profile (case sensstive): ' typed < /dev/tty

if [ "$typed" == "exit" ]; then
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Exiting the Sonarr Path Interface
---------------------------------------------------------------------------

EOF
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  exit
else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Sonarr Profile Set -- $typed
---------------------------------------------------------------------------

WARNING: Ensure that what you typed is a profile that exists within Sonarr!

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
echo "$typed" > /var/plexguide/pgtrak.sprofile
fi
