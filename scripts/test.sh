#!/bin/bash

dialog --title "Inputbox - To take input from you" \
--backtitle "Linux Shell Script Tutorial Example" \
--inputbox "Enter your name " 8 60 2>$OUTPUT

clear
echo "testfile"
echo "$tempfile"