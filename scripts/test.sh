docker logs traefik2 2> /var/plexguide/traefik.error2
docker logs traefik 2> /var/plexguide/traefik.error1
error2=$( cat /var/plexguide/traefik.error2 )
error2=${error2::-1}
error1=$( cat /var/plexguide/traefik.error2 )

if [ "$error2" == "$error1" ]
  then
    echo "Yup, both Bad"
  else
  	echo "Good"
fi