#!/bin/bash
[[ -z $@ ]] && maxgb=32 || maxgb=$@
rootdir=/mnt/move/movies
max=$(( maxgb * 1000000 ))
while true; do
	while [[ $(du /mnt/move -c | tail -1 | awk '{print $1}') -lt $max ]]; do
    flag=0
    dir=$(date +%H_%M_%S)
    file=500M_$RANDOM
    mkdir $rootdir/$dir
		echo "[INFO] Creating 500M random file: $file Dir size: $(du /mnt/move/ -hc | tail -1 | awk '{print $1}')"
		dd if=/dev/urandom of=$rootdir/$dir/$file bs=64M count=16 &>/dev/null
	done
sleep 1
[[ $flag == 0 ]] && echo "[WAIT] Size limit of $maxgb hit. Dir size: $(du /mnt/move/ -hc | tail -1 | awk '{print $1}' )" && flag=1
done
