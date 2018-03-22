#!/bin/bash
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flicker-Rate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
# REMOTE REQUIREMENTS:
# PlexGuide Dev on remote
# SSH key auth on remote
# iperf, permissive firewall
#
# LOCAL REQUIREMENTS:
# iperf, permissive firewall
#
# Install SSH keys on remote:
#
# Usage: ./tcp-bench <ip.address>
###################

trys=1
ip=195.201.98.159
bufferlen=8
time=60
size=200
skip_tags='bbr,mem,net,netsec'

FormatBytes() {
        bytes=${1%.*}
        local Mbps=$( printf "%s" "$bytes" | awk '{ printf "%.2f", $0 / 1024 / 1024 * 8 } END { if (NR == 0) { print "error" } }' )
        if [[ $bytes -lt 1000 ]]; then
                printf "%8i B/s |      N/A     "  $bytes
        elif [[ $bytes -lt 1000000 ]]; then
                local KiBs=$( printf "%s" "$bytes" | awk '{ printf "%.2f", $0 / 1024 } END { if (NR == 0) { print "error" } }' )
                printf "%7s KiB/s | %7s Mbps" "$KiBs" "$Mbps"
        else
                # awk way for accuracy
                local MiBs=$( printf "%s" "$bytes" | awk '{ printf "%.2f", $0 / 1024 / 1024 } END { if (NR == 0) { print "error" } }' )
                printf "%7s MiB/s | %7s Mbps" "$MiBs" "$Mbps"
                # bash way
                # printf "%4s MiB/s | %4s Mbps""$(( bytes / 1024 / 1024 ))" "$(( bytes / 1024 / 1024 * 8 ))"
        fi
}
pingtest() {
        # ping one time
        local ping_link=$( echo ${1#*//} | cut -d"/" -f1 )
        local ping_ms=$( ping -w1 -c1 $ping_link | grep 'rtt' | cut -d"/" -f5 )
        # get download speed and print
        if [[ $ping_ms == "" ]]; then
                printf " | ping error!"
        else
                printf " | ping %3i.%sms" "${ping_ms%.*}" "${ping_ms#*.}"
        fi
}
gdrive() {}
          # google drive speed test
          TMP_COOKIES="/tmp/cookies.txt"
          TMP_FILE="/tmp/gdrive"
          DRIVE="drive.google.com"
          FILE_ID="1EcDdTYwJNBIXx_BL6pzEkjTD_pkCbYni"
          printf " G-Drive   :"  | tee -a $log
          curl -c $TMP_COOKIES -o $TMP_FILE -s "https://$DRIVE/uc?id=$FILE_ID&export=download"
          D_ID=$( grep "confirm=" < $TMP_FILE | awk -F "confirm=" '{ print $NF }' | awk -F "&amp" '{ print $1 }' )
          C_DL=$( curl -m 4 -Lb $TMP_COOKIES -w '%{speed_download}\n' -o $NULL \
          -s "https://$DRIVE/uc?export=download&confirm=$D_ID&id=$FILE_ID" )
          printf "%s\n" "$(FormatBytes $C_DL) $(pingtest $DRIVE)" | tee -a $log
          echo "" | tee -a $log
}
benchmark(){
	ssh $ip "ansible-playbook /opt/plexguide/ansible/plexguide.yml\
		 --tags network_tuning --skip-tags $1 &>/dev/null"
  nohup ssh $ip 'reboot now' >nohup.out 2>&1 &
  gdrive
  sleep 60
  nohup ssh $ip 'nohup iperf -s' >nohup.out 2>&1 &
	sleep 10
	start=$(date +%s)

	for i in $(seq $trys); do
		iperf -c $ip -d -r -t $time  | grep Mbits >> $1
		echo -n '========='
	done
  nohup ssh $ip 'pkill iperf' >nohup.out 2>&1 &
	echo ''

	avgup=$(sed -n 2~2p $1 | awk '{ total += $7; count++ } END { print total/count }')
	avgdown=$(sed -n 1~2p $1 | awk '{ total += $7; count++ } END { print total/count }')
	end=$(date +%s)
	elapsed=$(( $end - $start ))
	minutes=$(( $elapsed / 60 ))

  if [[ $2 == 'baseline' ]]; then
    baseline_avgup=$avgup
    baseline_avgdown=$avgdown
  fi

  if [[ avgup != '' ]]; then
    perc_up=$(bc <<< "scale=2; ($baseline_avgup - $avgup)/$avgup * 100")
    perc_down=$(bc <<< "scale=2; ($baseline_avgdown - $avgdown)/$avgdown * 100")
  else
    perc_up=0
    perc_down=0
  fi

	echo "AVG Down Speed: $avgdown  ($perc_down%)"
	echo "AVG Up Speed  : $avgup  ($perc_up%)"
	echo "Elapsed Time: $minutes Minutes"
	echo "=============================="
	echo
  if [[ $2 == 'baseline' ]]; then
    baseline_avgup=$avgup
    baseline_avgdown=$avgdown
  fi
}


echo "PLEXGUIDE TCP TUNER BENCHMARK"
echo "=============================="
echo "Sample Size: $trys"
echo "Buffer Size: $bufferlen KB"
echo "TCP Window : 128 KB"
echo "Time       : $time seconds"
echo "=============================="
echo ""
echo "Baseline Test"
benchmark 'bbr,mem,netsec,net' baseline

echo "NET Test"
benchmark 'bbr,mem,netsec'

echo "BBR Test"
benchmark 'mem,net,netsec'

#echo "MEM Test"
#benchmark 'bbr,netsec,net'

#echo "BBR + NET Test"
#benchmark 'mem,netsec'

#echo "BBR + NET + MEM Test"
#benchmark 'netsec'

echo "BBR + NET + MEM + NETSEC Test"
benchmark 'testall'

# TUNING NOTES
# RUN #1 (nocix -> hetzner)
# Best: BBR + NET + MEM + NETSEC (kernel: 4.10 generic)
# renamed to bbrnet
