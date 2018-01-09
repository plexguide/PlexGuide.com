#! /bin/bash

BENCH=$(whiptail --title "Choose Benchmark Options" --checklist -- "Choose:" 20 30 15 \
  -info off \
  -io off \
  -cdn off \
  -northamerica off \
  -europe off \
  -asia off \
  -b off \
  -speed off \
  -share off \
  -help off \
  -about off \
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
    bash ./bench.sh $BENCH

  else
    echo No
    clear
    echo "Did not run benchmarks and information"
    echo
  fi

  read -n 1 -s -r -p "Press any key to continue "
  clear

exit
