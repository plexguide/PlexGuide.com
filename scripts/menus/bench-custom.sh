#!/bin/bash

BENCH=$(whiptail --title "Choose Benchmark Options" --checklist "Choose:" 20 30 15 \
  "John" "" off \
  "Glen" "" off \
  "Adam" "" off \
  "Becky" "" off \
  "Cheryl" "" off \
  "Michelle" "" off \
  3>&1 1>&2 2>&3)

echo "You chose $BENCH"

read -n 1 -s -r -p "Press any key to continue "
clear

exit
