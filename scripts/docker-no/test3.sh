#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test2.sh

echo "Starting Program" 

if [ ! -e "/opt/appdata/plexguide/date1" ]
then
	date +%s > /opt/appdata/plexguide/date1
    date1=$(awk '{print $1}' /opt/appdata/plexguide/date1)
    echo "a date never existed"
    echo "$date1"
else
	echo "file exists already"
	date1=$(awk '{print $1}' /opt/appdata/plexguide/date1)
	echo "$date1"
fi

date +%s > /opt/appdata/plexguide/date2
date2=$(awk '{print $1}' /opt/appdata/plexguide/date2)

total=$((date2-date1))

while [ "$total" -lt 90001 ]
do
	date +%s > /opt/appdata/plexguide/date2
    date2=$(awk '{print $1}' /opt/appdata/plexguide/date2)
	total=$((date2-date1))
	echo "total difference"
	echo "$total"
	sleep 5
done



