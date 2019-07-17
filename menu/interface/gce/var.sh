#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
echo 9 >/var/plexguide/menu.number

gcloud info | grep Account: | cut -c 10- >/var/plexguide/project.account

file="/var/plexguide/project.final"
if [ ! -e "$file" ]; then
  echo "[NOT SET]" >/var/plexguide/project.final
fi

file="/var/plexguide/project.processor"
if [ ! -e "$file" ]; then
  echo "NOT-SET" >/var/plexguide/project.processor
fi

file="/var/plexguide/project.location"
if [ ! -e "$file" ]; then
  echo "NOT-SET" >/var/plexguide/project.location
fi

file="/var/plexguide/project.ipregion"
if [ ! -e "$file" ]; then
  echo "NOT-SET" >/var/plexguide/project.ipregion
fi

file="/var/plexguide/project.ipaddress"
if [ ! -e "$file" ]; then
  echo "IP NOT-SET" >/var/plexguide/project.ipaddress
fi

file="/var/plexguide/gce.deployed"
if [ -e "$file" ]; then
  echo "Server Deployed" >/var/plexguide/gce.deployed.status
else
  echo "Not Deployed" >/var/plexguide/gce.deployed.status
fi
