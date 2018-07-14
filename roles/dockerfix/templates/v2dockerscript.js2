containers=$(comm -12 <(docker ps -a -q | sort) <(docker ps -q | sort))
for container in $containers;
do
    echo Stopping $container
    docker=$(docker stop $container)
done

sleep 9

for container in $containers;
do
    echo Starting $container
    docker=$(docker start $container)
done
