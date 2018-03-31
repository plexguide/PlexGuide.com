#!/bin/bash
#
# [Traefik V2]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & DesignGears
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
version=$( cat /var/plexguide/provider )

############################## NULL LEGACY
if [ "$version" == "null" ]
then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik 1>/dev/null 2>&1
fi
############################## CLOUDFLRARE
if [ "$version" == "cloudflare" ]
then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy,namecheap,gandi 1>/dev/null 2>&1
fi

############################## GANDI
if [ "$version" == "gandi" ]
then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy,namecheap,cloudflare 1>/dev/null 2>&1
fi

############################## GODADDY
if [ "$version" == "godaddy" ]
then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=namecheap,gandi,cloudflare 1>/dev/null 2>&1
fi

############################## NAMECHEAP
if [ "$version" == "namecheap" ]
then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik2 --skip-tags=godaddy,gandi,cloudflare 1>/dev/null 2>&1
fi