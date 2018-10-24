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
while [ "$break" == "no" ]; do

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

read -p 'Type the NEW PATH (follow example above): ' typed

################## Selection ########### START
if [ "$typed" == "1" ]; then
break=on
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
break=on
#### END FI #2
fi
done

if [ "$typed" == "3" ]; then
tee <<-EOF

---------------------------------------------------------------------------
Radarr Path
---------------------------------------------------------------------------

NOTE: In order for this to work, you must set the PATH to where Radarr is
actively scanning your movies.

Examples:
/mnt/unionfs/movies
/media/movies
/secondhd/movies

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "

read -p 'Type the Radarr Location Path (follow examples above): ' typed

  if [ "$typed" == "exit" ]; then
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Exiting the Radarr Path Interface
---------------------------------------------------------------------------

EOF
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  exit
else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Checking Path: $typed
---------------------------------------------------------------------------
EOF
sleep 1.5

##################################################### TYPED CHECKERS - START
  typed2=$typed
  bonehead=no
  ##### If BONEHEAD forgot to add a / in the beginning, we fix for them
  initial="$(echo $typed | head -c 1)"
  if [ "$initial" != "/" ]; then
    typed="/$typed"
    bonehead=yes
  fi
  ##### If BONEHEAD added a / at the end, we fix for them
  initial="${typed: -1}"
  if [ "$initial" == "/" ]; then
    typed=${typed::-1}
    bonehead=yes
  fi

  ##### Notify User is a Bonehead
  if [ "$bonehead" == "yes" ]; then
tee <<-EOF

---------------------------------------------------------------------------
ALERT: We Fixed Your Typos (pay attention to the example next time)
---------------------------------------------------------------------------

You Typed : $typed2
Changed To: $typed

EOF

read -n 1 -s -r -p "Press [ANY KEY] to Continue "
else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Input is Valid
---------------------------------------------------------------------------
EOF
  fi
##################################################### TYPED CHECKERS - START
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Checking if the Location is Valid
---------------------------------------------------------------------------
EOF
sleep 1.5

mkdir $typed/test 1>/dev/null 2>&1

file="$typed/test"
  if [ -e "$file" ]; then

tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Process Complete!
---------------------------------------------------------------------------

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
echo "$typed" > /var/plexguide/pgtrak.spath
  else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: $typed DOES NOT Exist!
---------------------------------------------------------------------------

Note: Restarting the Process! You must ensure that linux is able to READ
your location.

Advice: Exit PG and (Test) Type >>> mkdir $typed/testfolder

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
  fi

fi
### Final FI
fi

#### Final Done
done
