#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
docker ps -a --format "{{.Names}}"  > /pg/var/container.running

sed -i -e "/traefik/d" /pg/var/container.running
sed -i -e "/watchtower/d" /pg/var/container.running
sed -i -e "/wp-*/d" /pg/var/container.running
sed -i -e "/plex/d" /pg/var/container.running
sed -i -e "/bitwarden/d" /pg/var/container.running
sed -i -e "/ombi/d" /pg/var/container.running
sed -i -e "/portainer/d" /pg/var/container.running
sed -i -e "/dockergc/d" /pg/var/container.running

count=$(wc -l < /pg/var/container.running)
((count++))
((count--))

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  AppGuard - Rebuilding All Containers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

for ((i=1; i<$count+1; i++)); do
	app=$(sed "${i}q;d" /pg/var/container.running)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  AppGuard - Rebuilding $app
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
	sleep 2
	if [ -e "/opt/coreapps/apps/$app.yml" ]; then ansible-playbook /opt/coreapps/apps/$app.yml; fi
	if [ -e "/opt/coreapps/communityapps/$app.yml" ]; then ansible-playbook /opt/communityapps/apps/$app.yml; fi
done

echo ""
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  AppGuard - Completed! All Containers were Rebuilt!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p 'Continue? | Press [ENTER] ' name < /dev/tty
