#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test2.sh

echo "Starting Program" 

if [ ! -e "/opt/appdata/plexguide/date1" ]
then
	date -d '0 hour ago' '+%d' > /opt/appdata/plexguide/date1
    date1=$(awk '{print $1}' /opt/appdata/plexguide/date1)
    echo "a date never existed"
    echo "$date1"
else
	echo "file exists already"
	date1=$(awk '{print $1}' /opt/appdata/plexguide/date1)
	echo "$date1"
fi


while [ "$date1" == "$date2" ]
do
	date -d '0 hour ago' '+%d' > /opt/appdata/plexguide/date2
	date2=$(awk '{print $1}' /opt/appdata/plexguide/date2)
	echo "$date2"
	sleep 5
done

