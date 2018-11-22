ls -la /opt/plexguide/containers/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4  > /var/plexguide/app.list

sed -i -e "/traefik/d" /var/plexguide/container.running
sed -i -e "/watchtower/d" /var/plexguide/container.running
sed -i -e "/word*/d" /var/plexguide/container.running
sed -i -e "/plex/d" /var/plexguide/container.running
sed -i -e "/x2go*/d" /var/plexguide/container.running
sed -i -e "/bitwarden/d" /var/plexguide/container.running
sed -i -e "/ombi/d" /var/plexguide/container.running
sed -i -e "/portainer/d" /var/plexguide/container.running
