#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test2.sh

file="/var/plexguide/vnc.yes"
if [ -e "$file" ]
then
    date -d '0 hour ago' '+%d' > /opt/appdata/plexguide/date.txt
    echo "flag date set"
fi




#if [ ! -f /opt/appdata/plexguide/date1.txt ]
#	then
#   date -d '0 hour ago' '+%d' > /opt/appdata/plexguide/date.txt
#    echo "flag date set"
#fi

while [ 1 -lt 10000000 ]
do

	a=$(awk '{print 1}' /opt/appdata/plexguide/date.txt)
	echo  "$b"
	echo "flag1"
	
	if 
	then
	YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
	fi

	sleep 10
	$b=(date -d '0 hour ago' '+%d')
	echo "flag2"
done

