#! /bin/bash

BENCH=$(whiptail --title "Choose Benchmark Options" --checklist "Choose:" 20 30 15 \
  "John" "test" off \
  "Glen" "test1" off \
  "Adam" "test2" off \
  "Becky" "test3" off \
  "Cheryl" "test4" off \
  "Michelle" "test5" off \
  3>&1 1>&2 2>&3)

echo "You chose $BENCH"

read -n 1 -s -r -p "Press any key to continue "
clear

exit
