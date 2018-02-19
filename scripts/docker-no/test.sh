#!/bin/bash

while [ $pgpoll1 -ne $pgpoll2 ]
do
 
	pgpoll1=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo $pgpoll1
sleep 30
	pgpoll2=$(systemctl status move | grep "GBytes" | grep "MBytes" | awk '{print $7}') && echo $pgpoll2
done

echo "Final Transfer Output"
echo $pgpoll2