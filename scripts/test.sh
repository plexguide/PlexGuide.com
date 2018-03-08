#!/bin/bash

#OUTPUT="/tmp/input.txt"

dialog --title "Inputbox - To take input from you" \
--backtitle "Linux Shell Script Tutorial Example" \
--inputbox "Enter your name " 8 60 2>/tmp/input

corn=( cat /tmp/input )
echo "-----"
echo $input