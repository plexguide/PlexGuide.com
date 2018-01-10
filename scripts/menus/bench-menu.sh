#!/bin/bash

clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "Benchmark Menu (The Creator)" --menu "Make Your Choice!" 12 44 5 \
   "1)" "System Info and Benchmark - Basic"  \
   "2)" "System Info and Benchmark - Advanced"  \
   "3)" "System Info and Benchmark - Custom"  \
   "4)" "Simple Speedtest"  \
   "5)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in

     "1)")
     echo "Do you want to run BASIC benchmark and information? (y/n)? "
     old_stty_cfg=$(stty -g)
     stty raw -echo
     answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
     stty $old_stty_cfg
     if echo "$answer" | grep -iq "^y" ;then
         echo Yes;

     sudo wget -qO- bench.sh | bash

   else
       echo No
       clear
       echo "Did not run benchmark and information"
       echo
   fi

   read -n 1 -s -r -p "Press any key to continue "
   clear
   ;;

   "2)")
   echo "Do you want to run ADVANCED benchmark and information? (y/n)? "
   old_stty_cfg=$(stty -g)
   stty raw -echo
   answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
   stty $old_stty_cfg
   if echo "$answer" | grep -iq "^y" ;then
       echo Yes;

       curl -LsO raw.githubusercontent.com/thecreatorzone/plexguide-bench/master/bench.sh; chmod +x bench.sh; chmod +x bench.sh
       echo
       ./bench.sh -a

     else
       echo No
       clear
       echo "Did not run benchmark and information"
       echo
     fi

     read -n 1 -s -r -p "Press any key to continue "
     clear
     ;;

  "3)")
  bash /opt/plexguide/scripts/menus/bench-custom.sh
  ;;

  "4)")
  echo "Do you want to run a Speedtest? (y/n)? "
  old_stty_cfg=$(stty -g)
  stty raw -echo
  answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty $old_stty_cfg
  if echo "$answer" | grep -iq "^y" ;then
      echo Yes;

      pip install speedtest-cli

      echo
      speedtest-cli

    else
      echo No
      clear
      echo "Did not run Speedtest"
      echo
    fi

    read -n 1 -s -r -p "Press any key to continue "
    clear
    ;;

  "5)")
     clear
     exit 0
     ;;
esac
done
exit
