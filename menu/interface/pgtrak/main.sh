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

file="/var/plexguide/pgtrak.rprofile"
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

rpath=$(cat /var/plexguide/pgtrak.rpath)
spath=$(cat /var/plexguide/pgtrak.spath)
rprofile=$(cat /var/plexguide/pgtrak.rprofile)
sprofile=$(cat /var/plexguide/pgtrak.sprofile)

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

read -n 1 -s -r -p "Press [ANY KEY] to Continue " < /dev/tty
echo
while [ "$typed" != "1" ]; do
################## Selection ########### START
tee <<-EOF

---------------------------------------------------------------------------
PG Traefik Deployment Interface - Reverse Proxy
---------------------------------------------------------------------------

NOTE: Making Changes? Redeploy PGTrak When Complete!

1.  Exit the PGTrak Interface
2.  Trakt API-Key    :  [$api]
3.  Sonarr Movie Path:  [$spath]
4.  Radarr Movie Path:  [$rpath]
5.  Sonarr Profile   :  [$sprofile]
6.  Radarr Profile   :  [$rprofile]
7.  Deploy PGTrak

EOF

read -p 'Type a Number Selection | PRESS [ENTER]: ' typed < /dev/tty

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
read -p 'Type the API Client: ' typed
echo $typed > /var/plexguide/pgtrak.client
read -p 'Type the API Secret: ' typed
echo $typed > /var/plexguide/pgtrak.secret
tee <<-EOF

---------------------------------------------------------------------------
PGTrak API Notice
---------------------------------------------------------------------------

NOTE: The API Client and Secret is set! Ensure to setup your <paths> and
<profiles> prior to deploying PGTrak.

INFO: Messed up? Rerun this API Interface to update the information!

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue " < /dev/tty
echo
break=yes
#### END FI #2
fi

  if [ "$typed" == "3" ]; then
  bash /opt/plexguide/menu/interface/pgtrak/spath.sh
  fi

  if [ "$typed" == "4" ]; then
  bash /opt/plexguide/menu/interface/pgtrak/rpath.sh
  fi

  if [ "$typed" == "5" ]; then
  bash /opt/plexguide/menu/interface/pgtrak/sprofile.sh
  fi

  if [ "$typed" == "6" ]; then
  bash /opt/plexguide/menu/interface/pgtrak/rprofile.sh
  fi

if [ "$typed" == "7" ]; then

#################################################### API - START
  if [ "$api" == "NOT-SET" ]; then
tee <<-EOF
---------------------------------------------------------------------------
WARNING: API Condition Not Met!
---------------------------------------------------------------------------

Please Set Your API!

EOF

    read -n 1 -s -r -p "Press [ANY KEY] to Continue " < /dev/tty
else

#################################################### API - END
sonarr=$(docker ps | grep "sonarr")
radarr=$(docker ps | grep "radarr")

  if [ "$radarr" == "" ] && [ "$sonarr" == "" ]; then
  tee <<-EOF
---------------------------------------------------------------------------
WARNING: Sonarr | Radarr Warning!
---------------------------------------------------------------------------

You must at least deploy Radarr and/or Sonarr First before deploying
PGTrak!

EOF

read -n 1 -s -r -p "Press [ANY KEY] to Continue " < /dev/tty
echo
else

file="/opt/appdata/radarr/config.xml"
if [ -e "$file" ]
then
info=$( cat /opt/appdata/radarr/config.xml )
info=${info#*<ApiKey>} 1>/dev/null 2>&1
info1=$( echo ${info:0:32} ) 1>/dev/null 2>&1
echo "$info1" > /var/plexguide/pgtrak.rapi
fi

file="/opt/appdata/sonarr/config.xml"
if [ -e "$file" ]
then
info=$( cat /opt/appdata/sonarr/config.xml )
info=${info#*<ApiKey>} 1>/dev/null 2>&1
info2=$( echo ${info:0:32} ) 1>/dev/null 2>&1
echo "$info2" > /var/plexguide/pgtrak.sapi
fi

ansible-playbook /opt/plexguide/menu/interface/pgtrak/main.yml

tee <<-EOF

---------------------------------------------------------------------------
PGTrak Deployed!
---------------------------------------------------------------------------

PGTrak is deployed! Exit PlexGuide and Type (based on choice):

1. pgtrak

2.
 a. (Sonarr) pgtrak shows
 b. (Radarr) pgtrack movies

3.
 a. (Sonarr) pgtrak shows -t trending  or pgtrak shows -t popular
 b. (Radarr) pgtrak movies -t trending or pgtrak movies -t popular

EOF

read -n 1 -s -r -p "Press [ANY KEY] to Continue - Process Complete! " < /dev/tty
echo
  fi
fi
fi
#### Final Done
api=$(cat /var/plexguide/pgtrak.secret)
  if [ "$api" == "NOT-SET" ]; then
    api="NOT-SET"
  else
    api="SET"
  fi
rpath=$(cat /var/plexguide/pgtrak.rpath)
spath=$(cat /var/plexguide/pgtrak.spath)
rprofile=$(cat /var/plexguide/pgtrak.rprofile)
sprofile=$(cat /var/plexguide/pgtrak.sprofile)
done
done
