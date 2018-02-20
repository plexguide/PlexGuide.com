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

## 90001
while [ "a" == "a" ]
do
	date +%s > /opt/appdata/plexguide/date2
    date2=$(awk '{print $1}' /opt/appdata/plexguide/date2)
	total=$((date2-date1))
	echo "total difference"
	echo "$total"
	sleep 5

	if [ "$total" -gt 90001 ]; then
		date +%s > /opt/appdata/plexguide/date1
		date1=$(awk '{print $1}' /opt/appdata/plexguide/date1)
 		echo 0 > /opt/appdata/plexguide/data
 		echo "on" > /opt/appdata/plexguide/switch
		systemctl restart transfer
		echo "Restarting Transfer"
    fi
    total=$((date2-date1))
done

echo "Program Exited Incorrectly"
