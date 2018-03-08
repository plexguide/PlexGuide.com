#!/bin/bash

dialog --infobox "Wait 4 seconds" 0 0 ; sleep 4

dialog --title "name" --inputbox "Put your name:" 0 0 2> $tempfile

clear
echo "testfile"
echo "$tempfile"