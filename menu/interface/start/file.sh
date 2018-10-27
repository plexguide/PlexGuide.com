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
pgversion=$(cat /var/plexguide/pg.number)
pgid=$(cat /var/plexguide/server.id)
pgdomain=$(cat /var/plexguide/server.domain)
pgedition=$(cat /var/plexguide/pg.edition)
aversion=$(ansible --version | cut -d' ' -f2 | head -n1)

  serverports=$(cat /var/plexguide/server.ports)
  if [ "$serverports" == "" ]; then
    serverports="Open"
    else
    serverports="Closed"
  fi

  appguard=$(cat /var/plexguide/server.ht)
  if [ "$appguard" == "" ]; then
    appguard="Not Enabled"
    else
    appguard="Enabled"
  fi
################## Selection ########### END
echo ""
tee <<-EOF
-----------------------------------------------------------------------
$pgedition - $pgversion | Server ID: $pgid
Domain: $pgdomain | Ansible: $aversion
-----------------------------------------------------------------------

1.  EXIT PlexGuide
2.  PG Mounts & Data Transport System
3.  Traefik & TLD Deployment   [$tldprogram]
4.  Server Port Guard - Ports  [$serverports]
5.  PG Application Guard       [$appguard]
6.  Program Suite Installer
7.  PG Trak - Fills Up Radarr & Sonarr
8.  PG Automations - Deploy GCE Feeder Instance
9.  Server VPN Service Installer
10. System & Network Auditor
11. PG Backup & Restore System
12. Settings Menu
13. TroubleShoot - PreInstaller & UnInstaller

EOF

################## Selection ########### START
typed=nullstart
prange="1 2 3 4 5 6 7 8 9 10 11 12 13"
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

  echo 'INFO - Selected: Deploy a Mount System' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  edition=$(cat /var/plexguide/pg.edition.stored)
  if [ "$edition" == "PG Edition - HD Solo" ]; then
    echo ""
    echo "Utilizing the HD Solo Edition! Cannot Setup HDs!"
    echo "Note: Data Stored via the Solo HD @ /mnt"
    echo ""
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  elif [ "$edition" == "PG Edition - HD Multi" ]; then
    echo ""
    bash /opt/plexguide/roles/menu-multi/scripts/main.sh
  else
    bash /opt/plexguide/roles/menu-transport/scripts/main.sh
  fi

elif [ "$typed" == "3" ]; then

  echo 'INFO - Selected: Traefik & TLD' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ### Affects Only Multi-HD and No Mount Is Deployed!
  multi=$(cat /var/plexguide/multi.unionfs)
  edition=$(cat /var/plexguide/pg.edition.stored)

  if [ "$edition" == "PG Edition - HD Multi" ] && [ "$multi" == "" ]; then
    echo ""
    echo "WARNING: You cannot proceed! Deploy one mount with UNIONFS first!"
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/menu/interface/traefik/main.sh
  fi

elif [ "$typed" == "4" ]; then

  echo 'INFO - Selected: Ports Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ### Affects Only Multi-HD and No Mount Is Deployed!
  multi=$(cat /var/plexguide/multi.unionfs)
  edition=$(cat /var/plexguide/pg.edition.stored)

  if [ "$edition" == "PG Edition - HD Multi" ] && [ "$multi" == "" ]; then
    echo ""
    echo "WARNING: You cannot proceed! Deploy one mount with UNIONFS first!"
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/roles/menu-ports/scripts/main.sh
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

elif [ "$typed" == "6" ]; then

  echo 'INFO - Selected: PG Program Suite' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  ### Affects Only Multi-HD and No Mount Is Deployed!
  multi=$(cat /var/plexguide/multi.unionfs) 1>/dev/null 2>&1
  edition=$(cat /var/plexguide/pg.edition.stored) 1>/dev/null 2>&1

  if [ "$edition" == "PG Edition - HD Multi" ] && [ "$multi" == "" ]; then
    echo ""
    echo "WARNING: You cannot proceed! Deploy one mount with UNIONFS first!"
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/menu/interface/apps/main.sh
  fi

elif [ "$typed" == "7" ]; then

  echo 'INFO - Selected: PLEX Enhancements' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menu/interface/pgtrak/main.sh

elif [ "$typed" == "8" ]; then

  echo 'INFO - Selected: PG GCE Feeder Automations' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo gce > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

elif [ "$typed" == "9" ]; then

  echo 'INFO - Selected: PG VPNServer' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo vpnserver > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

elif [ "$typed" == "10" ]; then

  echo 'INFO - Selected: Auditor' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/roles/menu-network/scripts/main.sh

elif [ "$typed" == "11" ]; then

  echo 'INFO - Selected: Backup & Restore' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

  edition=$(cat /var/plexguide/pg.edition.stored)
  if [ "$edition" == "PG Edition - HD Solo" ]; then
    echo ""
    echo "Utilizing the HD Solo Edition! Cannot Backup or Restore!"
    echo "Note: This Version has No GDrive to Backup or Restore From!"
    echo ""
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  elif [ "$edition" == "PG Edition - HD Multi" ]; then
    echo ""
    echo "Utilizing the HD Multi Edition! Cannot Backup or Restore!"
    echo "Note: This Version has No GDrive to Backup or Restore From!"
    echo ""
    read -n 1 -s -r -p "Press [ANY] Key to Continue"
  else
    bash /opt/plexguide/roles/b-control/scripts/main.sh
  fi

elif [ "$typed" == "12" ]; then

  echo 'INFO - Selected: Settings' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "settings" > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

elif [ "$typed" == "13" ]; then

  echo 'INFO - Selected: PG Server Information' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  echo "tshoot" > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

else
  typed="1"
  echo ""
  bash /opt/plexguide/roles/ending/ending.sh
  exit
fi
################## End State ########### STARTED
done
