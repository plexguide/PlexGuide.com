#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test.sh

a="1"
b="2"

while [ "$a" -ne "$b" ]
do

### Poll #1
echo "On Poll 1"
	a=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && let "a += 0"
#echo "$a"

#sleep 20
#echo "On Poll 2"
### Poll #2	
	#b=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo "$((b + 0))" | bc -l 
#echo "$b"

#done

#echo "Final Transfer Output"
#echo "$b"