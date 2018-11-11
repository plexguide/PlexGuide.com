#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
tee <<-EOF

---------------------------------------------------------------------------
Sonarr Path
---------------------------------------------------------------------------

NOTE: In order for this to work, you must set the PATH to where Sonarr is
actively scanning your tv shows.

Examples:
/mnt/unionfs/tv
/media/tv
/secondhd/tv

EOF
read -p 'Type the Sonarr Location (follow examples): ' typed < /dev/tty

  if [ "$typed" == "exit" ]; then
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Exiting the Sonarr Path Interface
---------------------------------------------------------------------------

EOF
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  exit
else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Checking Path: $typed
---------------------------------------------------------------------------
EOF
sleep 1.5

##################################################### TYPED CHECKERS - START
  typed2=$typed
  bonehead=no
  ##### If BONEHEAD forgot to add a / in the beginning, we fix for them
  initial="$(echo $typed | head -c 1)"
  if [ "$initial" != "/" ]; then
    typed="/$typed"
    bonehead=yes
  fi
  ##### If BONEHEAD added a / at the end, we fix for them
  initial="${typed: -1}"
  if [ "$initial" == "/" ]; then
    typed=${typed::-1}
    bonehead=yes
  fi

  ##### Notify User is a Bonehead
  if [ "$bonehead" == "yes" ]; then
tee <<-EOF

---------------------------------------------------------------------------
ALERT: We Fixed Your Typos (pay attention to the example next time)
---------------------------------------------------------------------------

You Typed : $typed2
Changed To: $typed

EOF

read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo
else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Input is Valid
---------------------------------------------------------------------------
EOF
  fi
##################################################### TYPED CHECKERS - START
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Checking if the Location is Valid
---------------------------------------------------------------------------
EOF
sleep 1.5

mkdir $typed/test 1>/dev/null 2>&1

file="$typed/test"
  if [ -e "$file" ]; then

tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Process Complete! Path is Now Set for Sonarr!
---------------------------------------------------------------------------

EOF

### Removes /mnt if /mnt/unionfs exists
check=$(echo $typed | head -c 12)
if [ "$check" == "/mnt/unionfs" ]; then
typed=${typed:4}
fi

read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
echo "$typed" > /var/plexguide/pgtrak.spath
  else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: $typed DOES NOT Exist! No Changes Made!
---------------------------------------------------------------------------

Note: Exiting the Process! You must ensure that linux is able to READ
your location.

Advice: Exit PG and (Test) Type >>> mkdir $typed/testfolder

EOF
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
echo ""
  fi

fi
