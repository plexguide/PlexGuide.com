#! /bin/bash

BENCH=$(whiptail --title "Choose Benchmark Options" --checklist -- "Choose:" 20 30 15 \
  "-info" "System Information"off \
  "-io" "System I/O Test" off \
  "-cdn" "CDN Test Download (200MB)" off \
  "-northamerica" "North-American Server Test Download (800MB)" off \
  "-europe" "European Server Test Download (900MB)" off \
  "-asia" "Asian Server Test Download (400MB)" off \
  "-b" "System Information, CDN Download Test & I/O Test" off \
  "-speed" "Network Speedtest Using speedtest-cli" off \
  "-share" "Share Your Results With Others!" off \
  "-help" "Help Menu. Do NOT Execute This With Other Options!" off \
  "-about" "Show About-Info. Do NOT Execute This With Other Options!" off \
  3>&1 1>&2 2>&3)

  echo "You chose the following options: $BENCH"
  echo

while read $BENCH
do
  echo "Do you want to run CUSTOM benchmark and information? (y/n)? "
  old_stty_cfg=$(stty -g)
  stty raw -echo
  answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty $old_stty_cfg
  if echo "$answer" | grep -iq "^y" ;then
    echo Yes;

    curl -LsO raw.githubusercontent.com/sayem314/serverreview-benchmark/master/bench.sh; chmod +x bench.sh
    echo
    ./bench.sh $BENCH

  else
    echo No
    clear
    echo "Did not run benchmarks and information"
    echo
  fi
fi
  read -n 1 -s -r -p "Press any key to continue "
  clear

exit
