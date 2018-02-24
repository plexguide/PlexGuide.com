#!/bin/bash

MAXCOUNT=1
count=1

while [ "$count" -le $MAXCOUNT ]
do
  number=$RANDOM
  let "count += 1"  # Increment count.
done

## so if the highest number is 10, the range must be 11 - Range = maxnumber + 1
RANGE=6

number=$RANDOM
let "number %= $RANGE"

if [ "$number" -eq "0" ]
then
	dialog --title "Plex Claim Info" \
	--msgbox "\nDid you know that you can type - sudo pgupdate - from the terminal prompt and plexguide will update itself?" 10 50
fi

if [ "$number" -eq "1" ]
then
	dialog --title "Plex Claim Info" \
	--msgbox "\nSee issues with our Wiki Pages? Please comment in the forum and we will udpdate! Once an offical wiki plugin is built, we'll add it!" 11 50
fi

if [ "$number" -eq "2" ]
then
   whiptail --title "Startup Message" --msgbox "Visit our Forum at https://plexguide.com!" 8 66
fi

if [ "$number" -eq "3" ]
then
   whiptail --title "Startup Message" --msgbox "Did you log into GITHUB and click the STAR in the upper right? Doing so further supports our project and awareness! Even making an account just do so means a-lot to us!" 11 66
fi

if [ "$number" -eq "4" ]
then
   whiptail --title "Startup Message" --msgbox "We are looking for CODERS; even ones with limited experience! Want to improve your skills without drama? Join our TEAM! Trust me, we are new coders ourselves!" 11 66
fi

if [ "$number" -eq "5" ]
then
   whiptail --title "Startup Message" --msgbox "Development cost are about 100 - 150 a month! If you can donate on the front page, it will help a-ton!" 11 66
fi

echo
exit 0
