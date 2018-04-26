#!/bin/bash
[[ -z $@ ]] && maxgb=32 || maxgb=$@
rootdir=/mnt/move/movies
flag=0
max=$(( maxgb * 1000000 ))
while true; do
	while [[ $(du /mnt/move -c | tail -1 | awk '{print $1}') -lt $max ]]; do
    flag=0
    dir="$(date +%H_%M_%S) ($RANDOM) [$RANDOM]"
    mkdir $rootdir/"${dir}"
    for i in $(seq $(( RANDOM % 2 + 1))); do
        file="500M $RANDOM.junk"
        size=$(shuf -i16-32 -n1)
	      [[ $(du /mnt/move -c | tail -1 | awk '{print $1}') -lt $max ]] || break
		    echo "[INFO] Creating ${size}M random file: $file Dir size: $(du /mnt/move/ -hc | tail -1 | awk '{print $1}')"
		    dd if=/dev/urandom of=$rootdir/"${dir}"/"${file}" bs=64M count=$size &>/dev/null
      done
	done
sleep 1
[[ $flag == 0 ]] && echo "[WAIT] Size limit of $maxgb hit. Dir size: $(du /mnt/move/ -hc | tail -1 | awk '{print $1}' )" && flag=1
done
