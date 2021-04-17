#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###


## Establish Basic Users and Group Permissions
usermod -u 99 -g 100 nobody
usermod -a -G users nobody

## Install the Lastest Version of Docker | Align Permissions
if [[ -e "/usr/bin/docker" ]]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
fi
chmod 0755 /usr/bin/docker
chown nobody:users /usr/bin/docker
