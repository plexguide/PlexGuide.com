#!/bin/bash
### bash /opt/plexguide/scripts/docker-no/test.sh

# 1307068 = 1.3 GB
# 10000000 = 10 GB



a=$(du -la /mnt/move | grep "/mnt/move" | tail -1 | awk '{print $1}') && echo "$((a + 0))"
echo "first flag"
echo ""

	
while [ 1 -lt 1000 ]
do

	while [ "$a" -lt 1000000 ]
	do

	a=$(du -la /mnt/move | grep "/mnt/move" | tail -1 | awk '{print $1}') && echo "$((a + 0))"

	sleep 5

		echo "flag"
		echo ""

	done

		rclone move --tpslimit 6 --exclude='**partial~' --exclude="**_HIDDEN~" --exclude=".unionfs/**" --exclude=".unionfs-fuse/**" --no-traverse --checkers=16 --max-size 99G --log-level INFO --stats 5s /mnt/move gdrive:/
		sleep 300

done



### Poll #1
#echo "On Poll 1"
#	a=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo "$((a + 0))" | clisp --quiet -x '(+ 1.5 "$a")'
#echo "$a"

#sleep 20
#echo "On Poll 2"
### Poll #2	
#	b=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo "$((b + 0))" > /dev/null 2>&1 | bc -l 
#echo "$b"

#done