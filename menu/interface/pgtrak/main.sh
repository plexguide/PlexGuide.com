#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 < /dev/tty
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
file="/var/plexguide/pgtrak.client"
if [ ! -e "$file" ]; then
echo "NOT-SET" > /var/plexguide/pgtrak.client
fi

file="/var/plexguide/pgtrak.secret"
if [ ! -e "$file" ]; then
echo "NOT-SET" > /var/plexguide/pgtrak.secret
fi

file="/var/plexguide/pgtrak.rpath"
if [ ! -e "$file" ]; then
echo "NOT-SET" > /var/plexguide/pgtrak.rpath
fi

file="/var/plexguide/pgtrak.spath"
if [ ! -e "$file" ]; then
echo "NOT-SET" > /var/plexguide/pgtrak.spath
fi

file="/var/plexguide/pgtrak.sprofile"
if [ ! -e "$file" ]; then
echo "NOT-SET" > /var/plexguide/pgtrak.sprofile
fi

file="/var/plexguide/pgtrak.rpath"
if [ ! -e "$file" ]; then
echo "NOT-SET" > /var/plexguide/pgtrak.rprofile
fi

api=$(cat /var/plexguide/pgtrak.secret)
if [ "$api" == "NOT-SET" ]; then
  api="NOT-SET"
else
  api="SET"
fi

break=no
while [ "$break" != "yes" ]; do

tee <<-EOF

---------------------------------------------------------------------------
PGTrak Deployment Interface
---------------------------------------------------------------------------

NOTE: Welcome to PGTrak, a forked version of Trakktar that adapts to PG.

PURPOSE: PGTrak enables a user to STUFF Radarr and Sonarr with tons of tv
shows and/or movies without having to manually search for every single
item on their own.  PGTrak is useful for with the PG Google GCE Feeder
Edition.

WARNING: PGTrak fills up Sonarr and Radarr extensively!

EOF

read -n 1 -s -r -p "Press [ANY KEY] to Continue "

while [ "$typed" != "1" ]; do
################## Selection ########### START
tee <<-EOF

---------------------------------------------------------------------------
PG Traefik Deployment Interface - Reverse Proxy
---------------------------------------------------------------------------

NOTE: Making Changes? Redeploy PGTrak When Complete!

1.  Exit the PGTrak Interface
2.  Trakt API-Key    : [$api]
3.  Radarr Movie Path: [$rpath]
4.  Radarr Profile   : [$rprofile]
5.  Sonarr Movie Path: [$spath]
6.  Sonarr Profile   : [$sprofile]
7.  Deploy PGTrak

EOF

read -p 'Type the NEW PATH (follow example above): ' typed < /dev/tty

################## Selection ########### START
if [ "$typed" == "1" ]; then
break=yes
fi

if [ "$typed" == "2" ]; then
tee <<-EOF

---------------------------------------------------------------------------
Trakt API-Key
---------------------------------------------------------------------------

NOTE: In order for this to work, you must retrieve your API Key! Prior to
continuing, please follow the current steps.

- Visit - https://trakt.tv/oauth/applications
- Click - New Applications
- Name  - Whatever You Like
- Redirect UI - https://google.com
- Permissions - Click /checkin and /scrobble
- Click - Save App
- Copy the Client ID & Secret for the Next Step!

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""

read -p 'Type the API Client: ' typed
echo $typed > /var/plexguide/pgtrak.client
read -p 'Type the API Secret: ' typed
echo $typed > /var/plexguide/pgtrak.secret
tee <<-EOF

---------------------------------------------------------------------------
PGTrak API Notice
---------------------------------------------------------------------------

NOTE: The API key is set! Ensure to setup your PATHS and Profiles Prior
to deploying your API Profile. Messed up? You can rerun this API Interface
to update your information!

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue " < /dev/tty
echo
break=yes
#### END FI #2
fi

if [ "$typed" == "3" ]; then
bash /opt/plexguide/menu/interface/pgtrak/rpath.sh
fi


#### Final Done
done
done
