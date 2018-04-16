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


# weighted random number generator for network blinky lights

# USAGE:
# b_gen <num_lights> <light_off_weight> <light_green_weight> <light_red_weight>
# returns random weighted matrix array: ${blinkylights[@]}
b_gen(){
	num_lights=$1; zero_weight=$2; one_weight=$3; two_weight=$4

	# parameterize vars
	sum_weight=$(( zero_weight + one_weight + two_weight ))
	one_weight=$((zero_weight + one_weight))
	two_weight=$((one_weight + one_weight))
	blinkylights=($(seq $num_lights))

	# generate 1 x $num_lights weighted matrix
	for i in ${!blinkylights[@]}; do
	  #rnd=$(( $RANDOM % sum_weight ))
	  rnd=$(shuf -i0-$sum_weight -n1)
	  if [[ $rnd -lt $zero_weight ]]; then
	    blinkylights[$i]=0
	  elif [[ $rnd -lt $one_weight ]]; then
	    blinkylights[$i]=1
	  else
	    blinkylights[$i]=2
	  fi
	done
}
#b_gen 20 20000 32 2334
#echo ${blinkylights[@]}
