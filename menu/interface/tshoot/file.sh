#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
menu=$(cat /var/plexguide/final.choice)

if [ "$menu" == "2" ]; then
  echo "0" > /var/plexguide/pg.preinstall.stored

  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Success! Exit & Restart PlexGuide!"
  echo "---------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi

if [ "$menu" == "3" ]; then
  echo "0" > /var/plexguide/pg.preinstall.stored
  echo "0" > /var/plexguide/pg.ansible.stored
  echo "0" > /var/plexguide/pg.rclone.stored
  echo "0" > /var/plexguide/pg.python.stored
  echo "0" > /var/plexguide/pg.docker.stored
  echo "0" > /var/plexguide/pg.docstart.stored
  echo "0" > /var/plexguide/pg.watchtower.stored
  echo "0" > /var/plexguide/pg.label.stored
  echo "0" > /var/plexguide/pg.alias.stored
  echo "0" > /var/plexguide/pg.dep

  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Success! Exit & Restart PlexGuide!"
  echo "---------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi

if [ "$menu" == "4" ]; then
  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Not Ready!"
  echo "---------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi

if [ "$menu" == "5" ]; then
  rm -r /etc/docker
  apt-get purge docker-ce
  rm -rf /var/lib/docker
  rm -r /var/plexguide/dep*
  echo "0" > /var/plexguide/pg.preinstall.stored
  echo "0" > /var/plexguide/pg.ansible.stored
  echo "0" > /var/plexguide/pg.rclone.stored
  echo "0" > /var/plexguide/pg.python.stored
  echo "0" > /var/plexguide/pg.docstart.stored
  echo "0" > /var/plexguide/pg.watchtower.stored
  echo "0" > /var/plexguide/pg.label.stored
  echo "0" > /var/plexguide/pg.alias.stored
  echo "0" > /var/plexguide/pg.dep

  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Success! Exit & Restart PlexGuide!"
  echo "---------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi

if [ "$menu" == "6" ]; then
  echo "uninstall" > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh

fi
