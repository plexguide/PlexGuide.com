#!/bin/bash
echo 'INFO - All Containers were Rebooted for Server Loadup' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

containers=$(comm -12 <(docker ps -a -q | sort) <(docker ps -q | sort))
for container in $containers;
do
    docker=$(docker stop $container)
done

sleep 1

for container in $containers;
do
    docker=$(docker start $container)
done
