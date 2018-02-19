#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test.sh

pgpolla="1"
pgpollb="2"

while [ "$pgpolla" -ne "$pgpollb" ]
do

### Poll #1
echo "On Poll 1"
	pgpolla=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo "$((pgpolla" + 0))"

sleep 20
echo "On Poll 2"
### Poll #2	
	pgpollb=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo "$((pgpollb" + 0))"

done

echo "Final Transfer Output"
echo $pgpollb