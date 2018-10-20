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
### Notes
# Ensure to Change Out Backup If Not Using for Solo HD

while [ "$typed" != "1" ]; do
################## Selection ########### START
tldprogram=$(cat /var/plexguide/tld.program)
pgdomain=$(cat /var/plexguide/server.domain)
pgemail=$(cat /var/plexguide/server.email)

  serverports=$(cat /var/plexguide/server.ports)
  if [ "$serverports" == "" ]; then
    serverports="Open"
    else
    serverports="Closed"
  fi

  file="/var/plexguide/traefik.provider"
  if [ ! -e "$file" ]; then
    echo NOT-SET > /var/plexguide/traefik.provider
    provider="NOT-SET"
  else
    provider=$(cat /var/plexguide/traefik.provider)
  fi
## Check for Traefik Running
deployed=$(docker ps --format '{{.Names}}' | grep traefik)

if [ "$deployed" == "traefik" ]; then
  deployed="Deployed"
else
  deployed="NOT Deployed"
fi

## To Get List for Rebuilding or TLD
  docker ps --format '{{.Names}}' > /tmp/backup.list
  sed -i -e "/traefik/d" /tmp/backup.list
  sed -i -e "/watchtower/d" /tmp/backup.list
  sed -i -e "/word*/d" /tmp/backup.list
  sed -i -e "/x2go*/d" /tmp/backup.list
  sed -i -e "/plexguide/d" /tmp/backup.list
  sed -i -e "/cloudplow/d" /tmp/backup.list
  sed -i -e "/phlex/d" /tmp/backup.list

  rm -rf /tmp/backup.build 1>/dev/null 2>&1
  #### Commenting Out To Let User See
  while read p; do
    echo -n $p >> /tmp/backup.build
    echo -n " " >> /tmp/backup.build
  done </tmp/backup.list
  running=$(cat /tmp/backup.list)
################## Selection ########### END
echo ""
tee <<-EOF
-----------------------------------------------------------------------
PG Traefik Deployment Interface - Reverse Proxy
-----------------------------------------------------------------------

1.  EXIT Treafik Interface
2.  Set Top Level Domain App   [$tldprogram]
3.  Set Treafik Provier        [$provider]
4.  Set Domain Provider        [$pgdomain]
5.  Set E-Mail Address         [$pgemail]
6.  Deploy Traefik             [$deployed]

EOF

################## Selection ########### START
typed=nullstart
prange="1 2 3 4 5"
tcheck=""
break=off
while [ "$break" == "off" ]; do

  read -p 'Type a Number Selection | PRESS [ENTER]: ' typed
  tcheck=$(echo $prange | grep $typed)
  echo ""

  if [ "$tcheck" == "" ] || [ "$typed" == "0" ]; then
    echo "--------------------------------------------------------"
    echo "SYSTEM MESSAGE: Failed! Type a Number from 1 to 13 "
    echo "--------------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    echo ""
    echo ""
  else
    break=on
  fi
done
################## Selection ########### END
if [ "$typed" == "2" ]; then

  typed=nullstart
  prange="$running"
  tcheck=""
  break=off
  while [ "$break" == "off" ]; do
    echo ""
tee <<-EOF
-----------------------------------------------------------------------
SYSTEM MESSAGE: Running Programs for the Top Level Domain (TLD)
-----------------------------------------------------------------------

PROGRAMS:
$running

EOF

    read -p 'Type a Running Program for TLD | PRESS [ENTER]: ' typed
    tcheck=$(echo $prange | grep $typed)
    echo ""

    if [ "$tcheck" == "" ] || [ "$typed" == "0" ]; then
      echo "--------------------------------------------------------"
      echo "SYSTEM MESSAGE: Failed! Type A Running Program "
      echo "--------------------------------------------------------"
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      echo ""
      echo ""
    else
tee <<-EOF
-----------------------------------------------------------------------
SYSTEM MESSAGE: TLD Application Set to: $typed
-----------------------------------------------------------------------

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
echo ""
break=on
    fi
  done

elif [ "$typed" == "3" ]; then

  typed=nullstart
  prange="cloudflare ducksdns gandiv5 godaddy namecheap ovh "
  tcheck=""
  break=off
  while [ "$break" == "off" ]; do
    echo ""
tee <<-EOF
-----------------------------------------------------------------------
SYSTEM MESSAGE: Type to Set the Name of a Provider for Traefik!
-----------------------------------------------------------------------

cloudflare
duckdns
gandiv5
godaddy
namecheap
ovh

EOF
    read -p 'Type a Provider Name (All LowerCase) | PRESS [ENTER]: ' typed
    tcheck=$(echo $prange | grep $typed)
    echo ""

    if [ "$tcheck" == "" ] || [ "$typed" == "0" ]; then
tee <<-EOF
-----------------------------------------------------------------------
SYSTEM MESSAGE: Failed! Restarting the Process Again!
-----------------------------------------------------------------------

NOTE:
Ensure what you type is all lowercase!

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
echo ""
    else
tee <<-EOF
-----------------------------------------------------------------------
SYSTEM MESSAGE: Success! Provider [$typed] Set!
-----------------------------------------------------------------------

EOF
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      break=on
      echo $typed > /var/plexguide/traefik.provider
    fi
  done

elif [ "$typed" == "4" ]; then

  echo 'INFO - Selected: Traefik & TLD' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ### Affects Only Multi-HD and No Mount Is Deployed!
  multi=$(cat /var/plexguide/multi.unionfs)
  edition=$(cat /var/plexguide/pg.edition.stored)

  if [ "$edition" == "PG Edition - HD Multi" ] && [ "$multi" == "" ]; then
    echo ""
    echo "WARNING: You cannot proceed! Deploy one mount with UNIONFS first!"
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/roles/menu-tld/scripts/submenu.sh
  fi

elif [ "$typed" == "5" ]; then

  echo 'INFO - Selected: Authentication Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ### Affects Only Multi-HD and No Mount Is Deployed!
  multi=$(cat /var/plexguide/multi.unionfs)
  edition=$(cat /var/plexguide/pg.edition.stored)

  if [ "$edition" == "PG Edition - HD Multi" ] && [ "$multi" == "" ]; then
    echo ""
    echo "WARNING: You cannot proceed! Deploy one mount with UNIONFS first!"
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/roles/menu-appguard/scripts/main.sh
  fi

else
  typed="1"
  echo ""
  echo 'INFO - Exiting PlexGuide & Display Ending Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/ending/ending.sh
  exit
fi
################## End State ########### STARTED
done
