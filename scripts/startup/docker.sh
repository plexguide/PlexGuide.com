#!/bin/bash

# Install Docker and Docker Composer / Checks to see if is installed also
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1 >/dev/null 2>&1 & disown
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose 1>/dev/null 2>&1

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d >/dev/null 2>&1 & disown
