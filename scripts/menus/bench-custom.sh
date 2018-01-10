#! /bin/bash
whiptail --title "Information" --msgbox "This is a custom benchmarking and speedtest script for your machine. From here you can manipulate which options you want to include in the test! You may only choose ONE, for now. You can return anytime by pressing Cancel. Select using Space & navigate with TAB and Up/Down Arrow keys. Press Enter to continue." 15 70

BENCH=$(whiptail --title "Choose Benchmark Options" --radiolist --separate-output -- "Choose:" 22 84 15 \
  -info "System Information" off \
  -io "System I/O Test" off \
  -cdn "CDN Test Download (200MB)" off \
  -northamerica "North-American Server Test Download (800MB)" off \
  -europe "European Server Test Download (900MB)" off \
  -asia "Asian Server Test Download (400MB)" off \
  -b "System Information, CDN Download Test & I/O Test" off \
  -speed "Network Speedtest Using speedtest-cli" off \
  -help "Help Menu" off \
  -about "Show About Info" off \
  3>&1 1>&2 2>&3)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    echo "You chose the following options:" $BENCH
      echo

    echo "Do you want to run CUSTOM benchmark and information? (y/n)? "
      old_stty_cfg=$(stty -g)
      stty raw -echo
      answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
      stty $old_stty_cfg
      if echo "$answer" | grep -iq "^y" ;then
        echo Yes;

      curl -LsO raw.githubusercontent.com/thecreatorzone/plexguide-bench/master/bench.sh; chmod +x bench.sh
      echo
      ./bench.sh $BENCH

    else
      echo No
      clear
      echo "Did not run benchmarks and information"

    fi

  echo
  read -n 1 -s -r -p "Press any key to continue"

  else
      exit
  fi

bash /opt/plexguide/scripts/menus/bench-custom.sh
#exit
