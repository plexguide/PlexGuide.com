#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
echo 9 > /pg/var/menu.number

gcloud info | grep Account: | cut -c 10- > /pg/var/project.account

file="/pg/var/project.final"
  if [ ! -e "$file" ]; then
    echo "[NOT SET]" > /pg/var/project.final
  fi

file="/pg/var/project.processor"
  if [ ! -e "$file" ]; then
    echo "NOT-SET" > /pg/var/project.processor
  fi

file="/pg/var/project.location"
  if [ ! -e "$file" ]; then
    echo "NOT-SET" > /pg/var/project.location
  fi

file="/pg/var/project.ipregion"
  if [ ! -e "$file" ]; then
    echo "NOT-SET" > /pg/var/project.ipregion
  fi

file="/pg/var/project.ipaddress"
  if [ ! -e "$file" ]; then
    echo "IP NOT-SET" > /pg/var/project.ipaddress
  fi

file="/pg/var/gce.deployed"
  if [ -e "$file" ]; then
    echo "Server Deployed" > /pg/var/gce.deployed.status
  else
    echo "Not Deployed" > /pg/var/gce.deployed.status
  fi
