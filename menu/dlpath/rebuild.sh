#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
docker ps -a --format "{{.Names}}" >/var/plexguide/container.running

sed -i -e "/traefik/d" /var/plexguide/container.running
sed -i -e "/watchtower/d" /var/plexguide/container.running
sed -i -e "/wp-*/d" /var/plexguide/container.running
sed -i -e "/plex/d" /var/plexguide/container.running
sed -i -e "/emby/d" /var/plexguide/container.running
sed -i -e "/jellyfin/d" /var/plexguide/container.running
sed -i -e "/pgblitz/d" /var/plexguide/container.running
sed -i -e "/oauth/d" /var/plexguide/container.running
sed -i -e "/dockergc/d" /var/plexguide/container.running
sed -i -e "/pgui/d" /var/plexguide/container.running

### Your Wondering Why No While Loop, using a While Loops Screws Up Ansible Prompts
### BackDoor WorkAround to Stop This Behavior
count=$(wc -l </var/plexguide/container.running)
((count++))
((count--))

for ((i = 1; i < $count + 1; i++)); do
	app=$(sed "${i}q;d" /var/plexguide/container.running)
	echo "$app" >/tmp/program_var
	if [ -e "/opt/coreapps/apps/$app.yml" ]; then ansible-playbook /opt/coreapps/apps/$app.yml; fi
	if [ -e "/opt/communityapps/$app.yml" ]; then ansible-playbook /opt/communityapps/apps/$app.yml; fi
done

echo ""
echo 'INFO - Rebuilding Complete!' >/var/plexguide/logs/pg.log && bash /opt/plexguide/menu/log/log.sh
