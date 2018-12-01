#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
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

rm -rf /var/plexguide/pg.exit 1>/dev/null 2>&1
