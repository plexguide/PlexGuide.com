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
   whiptail --title "Startup Message" --msgbox "Visit http://binance.plexguide.com to purchase crypto coins. Purchasing Ripple, Stellar, and Tron are the way to go. Any sign ups will help support future website server costs and possible prizes! I truly use the site myself!" 11 66
fi

if [ "$number" -eq "1" ]
then
   whiptail --title "Startup Message" --msgbox "Did you know you can edit our wiki pages? We truly rely on your help on providing screenshots or fixing mistakes to make the process better!" 10 66
fi

if [ "$number" -eq "2" ]
then
   whiptail --title "Startup Message" --msgbox "Visit our Discord Channel at http://discord.plexguide.com!" 8 66
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
   whiptail --title "Startup Message" --msgbox "Visit http://hitbtc.plexguide.com to puchase more crypto! Purchasing bytecoins which are now exploding! Good to trade currency without ID requirements. Signups help pay for some costs; but I personally use!" 11 66
fi

echo
exit 0
