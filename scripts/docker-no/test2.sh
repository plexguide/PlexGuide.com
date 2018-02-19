#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test2.sh

echo "Starting Program" 

if [ ! -e "/opt/appdata/plexguide/date1" ]
then
	date -d '0 hour ago' '+%d' > /opt/appdata/plexguide/date1
    date1=$(awk '{print $2}' /opt/appdata/plexguide/date1)
    echo "$date1"
    echo "a date never existed"
else
	echo "file exists already"
	cat /opt/appdata/plexguide/date1
	echo "$date1"
fi







#while [ 1 -lt 10000000 ]
#do

	#a=$(awk '{print 1}' /opt/appdata/plexguide/date.txt)
	echo  "$a"
	echo "flag1"
	
	#sleep 10
	#$b=(date -d '0 hour ago' '+%d')
	echo "$b"
	echo "flag2"

#done

