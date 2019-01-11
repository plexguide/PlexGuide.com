#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# Generates App List
ls -la /opt/plexguide/containers/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4  > /var/plexguide/app.list

ls -la /opt/mycontainers/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4  >> /var/plexguide/app.list
# Enter Items Here to Prevent them From Showing Up on AppList
sed -i -e "/traefik/d" /var/plexguide/app.list
sed -i -e "/image*/d" /var/plexguide/app.list
sed -i -e "/_appsgen.sh/d" /var/plexguide/app.list
sed -i -e "/_c*/d" /var/plexguide/app.list
sed -i -e "/_a*/d" /var/plexguide/app.list
sed -i -e "/_t*/d" /var/plexguide/app.list
sed -i -e "/templates/d" /var/plexguide/app.list
sed -i -e "/retry/d" /var/plexguide/app.list
sed -i "/^test\b/Id" /var/plexguide/app.list
sed -i -e "/nzbthrottle/d" /var/plexguide/app.list
sed -i -e "/watchtower/d" /var/plexguide/app.list
sed -i "/^_templates.yml\b/Id" /var/plexguide/app.list
sed -i -e "/oauth/d" /var/plexguide/app.list
sed -i -e "/dockergc/d" /var/plexguide/app.list
