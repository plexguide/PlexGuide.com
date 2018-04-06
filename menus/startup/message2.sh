#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
MAXCOUNT=1
count=1

while [ "$count" -le $MAXCOUNT ]
do
  number=$RANDOM
  let "count += 1"  # Increment count.
done

## so if the highest number is 10, the range must be 11 - Range = maxnumber + 1
RANGE=7

number=$RANDOM
let "number %= $RANGE"

if [ "$number" -eq "0" ]
then
	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nDid you know that you can type - sudo pgupdate - from the terminal prompt and plexguide will update itself?" 10 50
fi

if [ "$number" -eq "1" ]
then
	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nSee issues with our Wiki Pages? Please comment in the forum and we will update! Once an offical wiki plugin is built, we'll add it!" 10 50
fi

if [ "$number" -eq "2" ]
then
   	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nVisit our Forums via https://PlexGuide.com" 8 50
fi

if [ "$number" -eq "3" ]
then
   	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nDid you log into GITHUB and click the STAR in the upper right? Doing so further supports our project and awareness! Even making an account just do so means a lot to us!" 10 50
fi

if [ "$number" -eq "4" ]
then
   	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nWe are looking for CODERS; even ones with limited experience! Want to improve your skills without drama? Join our TEAM! Trust me, we are new coders ourselves!" 10 50
fi

if [ "$number" -eq "5" ]
then
   	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nDevelopment costs are 100 to 150 a month! Any type of donation is appreciated!" 9 50
fi

if [ "$number" -eq "6" ]
then
   	dialog --title "Startup Message - PlexGuide.com" \
	--msgbox "\nThe menus allow the use of HotKeys! Select the LETTER & Press Enter. The Letter Z is always Exit!" 9 50
fi

dialog --title "PLEXGUID Variable Page" --msgbox "\nLegacy Traefik works fine, but you will not be able to create custom subdomains and more limited in the amount of subdomains you can create per week. It is easier to setup though.\n\nVisit https://traefik.plexguide.com for more information." 0 0

