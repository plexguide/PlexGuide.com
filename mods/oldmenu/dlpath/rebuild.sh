#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
docker ps -a --format "{{.Names}}"  > /pg/tmp/container.running

sed -i -e "/traefik/d" /pg/tmp/container.running
sed -i -e "/watchtower/d" /pg/tmp/container.running
sed -i -e "/wp-*/d" /pg/tmp/container.running
sed -i -e "/plex/d" /pg/tmp/container.running
sed -i -e "/pgblitz/d" /pg/tmp/container.running
sed -i -e "/oauth/d" /pg/tmp/container.running
sed -i -e "/dockergc/d" /pg/tmp/container.running
sed -i -e "/pgui/d" /pg/tmp/container.running

### Your Wondering Why No While Loop, using a While Loops Screws Up Ansible Prompts
### BackDoor WorkAround to Stop This Behavior
count=$(wc -l < /pg/tmp/container.running)
((count++))
((count--))

for ((i=1; i<$count+1; i++)); do
	app=$(sed "${i}q;d" /pg/tmp/container.running)
	if [ -e "/pg/coreapps/apps/$app.yml" ]; then ansible-playbook /pg/coreapps/apps/$app.yml; fi
	if [ -e "/pg/coreapps/communityapps/$app.yml" ]; then ansible-playbook /pg/communityapps/apps/$app.yml; fi
done

echo ""
echo 'INFO - Rebuilding Complete!' > /pg/var/logs/pg.log && bash /pg/pgblitz/menu/log/log.sh
