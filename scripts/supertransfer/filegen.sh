#!/bin/bash
maxgb=32
max=$(( maxgb * 1000000 ))
while true; do
	while [[ $(du /mnt/move -c | tail -1 | awk '{print $1}') -lt $max ]]; do
    flag=0
		dd if=/dev/urandom of=/mnt/move/movies/$(date +%H_%M_%S)/1G_$(date +%H_%M_%S) bs=64M count=32 &>/dev/null
		echo "[INFO] 1G file created. Dir size: $(du /mnt/move/ -hc | tail -1)"
	done
sleep 1
[[ $flag == 0 ]] && echo "[WAIT] Max Size hit. Dir size: $(du /mnt/move/ -hc | tail -1)" && flag=1
done
