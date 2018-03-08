dialog --title "Inputbox - Example" \
--backtitle "unstableme.blogspot.com" \
--inputbox "Enter your favourite OS here" 0 0 $val 2> $tempfile

clear
echo "$tempfile"