#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
docker ps -a --format "{{.Names}}"  > /pg/tmp/container.running

sed -i -e "/traefik/d" /pg/tmp/container.running
sed -i -e "/watchtower/d" /pg/tmp/container.running
sed -i -e "/wp-*/d" /pg/tmp/container.running
sed -i -e "/plex/d" /pg/tmp/container.running
sed -i -e "/bitwarden/d" /pg/tmp/container.running
sed -i -e "/ombi/d" /pg/tmp/container.running
sed -i -e "/portainer/d" /pg/tmp/container.running
sed -i -e "/dockergc/d" /pg/tmp/container.running

count=$(wc -l < /pg/tmp/container.running)
((count++))
((count--))

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  AppGuard - Rebuilding All Containers
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

for ((i=1; i<$count+1; i++)); do
	app=$(sed "${i}q;d" /pg/tmp/container.running)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  AppGuard - Rebuilding $app
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
	sleep 2
	if [ -e "/pg/coreapps/apps/$app.yml" ]; then ansible-playbook /pg/coreapps/apps/$app.yml; fi
	if [ -e "/pg/coreapps/communityapps/$app.yml" ]; then ansible-playbook /pg/communityapps/apps/$app.yml; fi
done

echo ""
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  AppGuard - Completed! All Containers were Rebuilt!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p 'Continue? | Press [Enter] ' name < /dev/tty
