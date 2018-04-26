#!/bin/bash
#
# [PG Script]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   FlickerRate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
MAXCOUNT=1
count=1

while [ "$count" -le $MAXCOUNT ]
do
  number=$RANDOM
  let "count += 1"  # Increment count.
done

## so if the highest number is 10, the range must be 11 - Range = maxnumber + 1
RANGE=15

number=$RANDOM
let "number %= $RANGE"

if [ "$number" -eq "3" ]
then
dialog --title "PG Member NZB Specials" --msgbox "\nWe are partnered to provide our PG Members with Deep Discounts!\n\n1. newshosting.plexguide.com  - Free VPN & 41% Discount! Fastest!\n2. usenetserver.plexguide.com - Free VPN & 39% Discount! Well-Known!\n3. easynews.plexguide.com     - Top Speeds & Great Alternative!\n4. pureusenet.plexguide.com   - Pay Euros & Packages as Low as 1.83!\n5. xlned.plexguide.com        - Pay Euros & Packages as Low as 2.24!\n\n* gsuite.plexguide.com        - MEMBERS Get a FREE 14 Day Trial!\n* Require Servers for your needs? PM Davaz via Forums/Discord!\n\nIf you need the LINKS again, visit our Wiki!" 17 73
fi