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
sed -i -e "/ombi/d" /var/plexguide/container.running
sed -i -e "/oauth/d" /var/plexguide/container.running
sed -i -e "/portainer/d" /var/plexguide/container.running
sed -i -e "/dockergc/d" /var/plexguide/container.running

count=$(wc -l </var/plexguide/container.running)
((count++))
((count--))

tee <<-EOF
	
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⚠️  AppGuard - Rebuilding All Containers
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

for ((i = 1; i < $count + 1; i++)); do
	app=$(sed "${i}q;d" /var/plexguide/container.running)

	tee <<-EOF
		
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		↘️  AppGuard - Rebuilding $app
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		
	EOF
	sleep 2
	echo "$app" >/tmp/program_var
	
	if [ -e "/opt/coreapps/apps/$app.yml" ]; then ansible-playbook /opt/coreapps/apps/$app.yml; fi
	if [ -e "/opt/communityapps/$app.yml" ]; then ansible-playbook /opt/communityapps/apps/$app.yml; fi
done

echo ""
tee <<-EOF
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	✅️  AppGuard - Completed! All Containers were Rebuilt!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	
EOF
read -p 'Continue? | Press [ENTER] ' name </dev/tty
