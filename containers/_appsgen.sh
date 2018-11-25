#!/bin/bash
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
###############################################################################

# Generates App List
ls -la /opt/plexguide/containers/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4  > /var/plexguide/app.list

# Enter Items Here to Prevent them From Showing Up on AppList
sed -i -e "/traefik/d" /var/plexguide/app.list
sed -i -e "/image*/d" /var/plexguide/app.list
sed -i -e "/_appsgen.sh/d" /var/plexguide/app.list
sed -i -e "/_c*/d" /var/plexguide/app.list
sed -i -e "/_a*/d" /var/plexguide/app.list
sed -i -e "/_t*/d" /var/plexguide/app.list
sed -i -e "/templates/d" /var/plexguide/app.list
sed -i -e "/retry/d" /var/plexguide/app.list
sed -i -e "/test/d" /var/plexguide/app.list
sed -i -e "/nzbthrottle/d" /var/plexguide/app.list
sed -i -e "/watchtower/d" /var/plexguide/app.list
