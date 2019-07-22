#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq - Sub7Seven
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
docker ps -a --format "{{.Names}}" >/var/plexguide/container.running

sed -i -e "/traefik/d" /var/plexguide/container.running
sed -i -e "/watchtower/d" /var/plexguide/container.running
sed -i -e "/wp-*/d" /var/plexguide/container.running
sed -i -e "/x2go*/d" /var/plexguide/container.running
sed -i -e "/authclient/d" /var/plexguide/container.running
sed -i -e "/dockergc/d" /var/plexguide/container.running
sed -i -e "/oauth/d" /var/plexguide/container.running

count=$(wc -l </var/plexguide/container.running)
((count++))
((count--))

tee <<-EOF
	
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⚠️  PortGuard - Rebuilding Containers!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
for ((i = 1; i < $count + 1; i++)); do
	app=$(sed "${i}q;d" /var/plexguide/container.running)

	tee <<-EOF
		
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		↘️  PortGuard - Rebuilding [$app]
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		
	EOF
	echo "$app" >/tmp/program_var
	sleep 1

	if [ -e "/opt/coreapps/apps/$app.yml" ]; then ansible-playbook /opt/coreapps/apps/$app.yml; fi
	if [ -e "/opt/communityapps/$app.yml" ]; then ansible-playbook /opt/communityapps/apps/$app.yml; fi
done

echo ""
tee <<-EOF
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	✅️  PortGuard - All Containers Rebuilt!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	
EOF
read -p 'Continue? | Press [ENTER] ' name </dev/tty
