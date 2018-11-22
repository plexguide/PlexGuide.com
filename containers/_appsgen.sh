ls -la /opt/plexguide/containers/ | sed -e 's/.yml//g' \
| awk '{print $9}' | tail -n +4  > /var/plexguide/app.list

sed -i -e "/traefik/d" /var/plexguide/app.list
sed -i -e "/_appsgen.sh/d" /var/plexguide/app.list
sed -i -e "/_c*/d" /var/plexguide/app.list
sed -i -e "/_a*/d" /var/plexguide/app.list
