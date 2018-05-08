#!/bin/bash
#pg loading animation
speed=30000
loading=0

# check for pv program
[[ ! $(which pv) ]] && echo 'Please Install pv' && exit 1

# this changes behavior of ctrl-c
trap 'clear; exit 0' SIGINT

# change loading condition here
while [[ $loading -le 5 ]]; do
  cat pg_globe.txt | pv -qL $speed
  ((++loading))
done
