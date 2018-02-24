docker ps -a --format "{{.Names}}"  > /opt/appdata/plexguide/running

while read p; do
  echo $p
done </opt/appdata/plexguide/running