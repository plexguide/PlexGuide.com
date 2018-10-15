#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
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
mkdir -p /var/plexguide

file="/var/plexguide/pg.alias.stored"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > $file
  fi

  file="/var/plexguide/pg.watchtower.stored"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "0" > $file
    fi

    file="/var/plexguide/pg.edition.stored"
      if [ -e "$file" ]; then
        echo "" 1>/dev/null 2>&1
      else
        echo "0" > $file
      fi

      file="/var/plexguide/pg.edition"
        if [ -e "$file" ]; then
          echo "" 1>/dev/null 2>&1
        else
          echo "10000000" > $file
        fi

  file="/var/plexguide/pg.dependency.stored"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "0" > $file
    fi

  file="/var/plexguide/pg.cleaner.stored"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "0" > $file
    fi

  file="/var/plexguide/pg.rclone.stored"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "0" > $file
    fi

  file="/var/plexguide/pg.motd.stored"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "0" > $file
    fi

file="/var/plexguide/pg.ansible.stored"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > $file
  fi

file="/var/plexguide/pg.docker.stored"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > $file
  fi

file="/var/plexguide/pg.docstart.stored"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > $file
  fi

file="/var/plexguide/pg.folder.stored"
    if [ -e "$file" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "0" > $file
    fi

file="/var/plexguide/pg.id.stored"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > $file
  fi

file="/var/plexguide/pg.python.stored"
  if [ -e "$file" ]; then
    echo "" 1>/dev/null 2>&1
  else
    echo "0" > $file
  fi

file="/var/plexguide/server.ports"
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  touch /var/plexguide/server.ports
  echo "[OPEN]" > /var/plexguide/server.ports.status
  fi

  file="/var/plexguide/server.appguard"
    if [ -e "$file" ]
      then
    echo "" 1>/dev/null 2>&1
      else
    touch /var/plexguide/server.appguard 1>/dev/null 2>&1
    echo "[OFF]" > /var/plexguide/server.appguard
    fi

rm -r /var/plexguide/pg.exit 1>/dev/null 2>&1
