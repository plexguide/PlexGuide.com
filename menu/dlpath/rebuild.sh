#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
docker ps -a --format "{{.Names}}"  > /var/plexguide/container.running

sed -i -e "/traefik/d" /var/plexguide/container.running
sed -i -e "/watchtower/d" /var/plexguide/container.running
sed -i -e "/word*/d" /var/plexguide/container.running
sed -i -e "/plex/d" /var/plexguide/container.running
sed -i -e "/pgblitz/d" /var/plexguide/container.running
sed -i -e "/phlex/d" /var/plexguide/container.running
sed -i -e "/oauth/d" /var/plexguide/container.running

### Your Wondering Why No While Loop, using a While Loops Screws Up Ansible Prompts
### BackDoor WorkAround to Stop This Behavior
count=$(wc -l < /var/plexguide/container.running)
((count++))
((count--))

for ((i=1; i<$count+1; i++)); do
	app=$(sed "${i}q;d" /var/plexguide/container.running)
	ansible-playbook /opt/plexguide/containers/$app.yml
done

echo ""
echo 'INFO - Rebuilding Complete!' > /var/plexguide/pg.log && bash /opt/plexguide/menu/log/log.sh
