
dialog --title \
"name" --inputbox \
"Put your name:" 0 0 2> $tempfile

clear
echo "$tempfile"