#! /bin/bash

BENCH=$(whiptail --title "Choose Benchmark Options" --checklist "Choose:" 20 30 15 \
  "${BENCH[-info]}" "System Information" off \
  "${BENCH[-io]}" "System I/O Test" off \
  "${BENCH[-cdn]}" "CDN Test Download (200MB)" off \
  "${BENCH[-northamerica]}" "North-American Server Test Download (800MB)" off \
  "${BENCH[-europe]}" "European Server Test Download (900MB)" off \
  "${BENCH[-asia]}" "Asian Server Test Download (400MB)" off \
  "${BENCH[-b]}" "System Information, CDN Download Test & I/O Test" off \
  "${BENCH[-speed]}" "Network Speedtest Using speedtest-cli" off \
  "${BENCH[-share]}" "Share Your Results With Others!" off \
  "${BENCH[-help]}" "Help Menu. Do NOT Execute This With Other Options!" off \
  "${BENCH[-about]}" "Show About-Info. Do NOT Execute This With Other Options!" off \
  3>&1 1>&2 2>&3)

  echo "You chose the following options: $BENCH"
  echo

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

  read -n 1 -s -r -p "Press any key to continue "
  clear

exit
