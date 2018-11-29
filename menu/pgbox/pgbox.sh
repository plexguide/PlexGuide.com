#!/bin/bash
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
################################################################################

# FUNCTIONS START ##############################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
question1
}

exists () {
echo
read -p '⛔️ ERROR - APP ALREADY INSTALLED! | PRESS [ENTER] ' typed < /dev/tty
question1
}

initial () {
  rm -rf /var/plexguide/pgbox.output 1>/dev/null 2>&1
  rm -rf /var/plexguide/pgbox.buildup 1>/dev/null 2>&1
  rm -rf /var/plexguide/program.temp 1>/dev/null 2>&1
  rm -rf /var/plexguide/app.list 1>/dev/null 2>&1
  touch /var/plexguide/pgbox.output
  touch /var/plexguide/program.temp
  touch /var/plexguide/app.list
  touch /var/plexguide/pgbox.buildup

  bash /opt/plexguide/containers/_appsgen.sh
  docker ps | awk '{print $NF}' | tail -n +2 > /var/plexguide/pgbox.running

  #while read p; do
  #  sed -i -e "/$p/d" /var/plexguide/app.list
  #done </var/plexguide/pgbox.running

  #while read p; do
  #  echo -n $p >> /var/plexguide/program.temp
  #  echo -n " " >> /var/plexguide/program.temp
  #  num=$[num+1]
  #  if [ $num == 7 ]; then
  #    num=0
  #    echo " " >> /var/plexguide/program.temp
  #  fi
  #done </var/plexguide/app.list
}
# FIRST QUESTION

question1 () {
while read p; do
  sed -i -e "/$p/d" /var/plexguide/app.list
done </var/plexguide/pgbox.running

### here
rm -r /var/plexguide/program.temp
touch /var/plexguide/program.temp
num=0
while read p; do
  echo -n $p >> /var/plexguide/program.temp
  echo -n " " >> /var/plexguide/program.temp
  num=$[num+1]
  if [ "$num" == 7 ]; then
    num=0
    echo " " >> /var/plexguide/program.temp
  fi
done </var/plexguide/app.list

notrun=$(cat /var/plexguide/program.temp)
buildup=$(cat /var/plexguide/pgbox.output)

if [ "$buildup" == "" ]; then buildup="NONE"; fi

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Potential Apps to Install

$notrun

📂 Apps To Install

$buildup

Quit? Type > exit | Ready to Mass Install? Type > deploy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p 'Type App to Add for Mass Install | Press [ENTER]: ' typed < /dev/tty
echo

current=$(cat /var/plexguide/pgbox.buildup | grep "\<$typed\>")
if [ "$current" != "" ]; then exists && question1; fi

current=$(cat /var/plexguide/program.temp | grep "\<$typed\>")
if [ "$current" == "" ]; then badinput && question1; fi

echo "typed" >> /var/plexguide/pgbox.buildup
num=0

touch /var/plexguide/pgbox.output && rm -rf /var/plexguide/pgbox.output

while read p; do
echo -n $typed >> /var/plexguide/pgbox.output
echo -n " " >> /var/plexguide/pgbox.output
if [ "$num" == 7 ]; then
  num=0
  echo " " >> /var/plexguide/pgbox.output
fi
done </var/plexguide/pgbox.buildup

sed -i -e "/$typed/d" /var/plexguide/app.list

question1
}

# FUNCTIONS END ##############################################################
initial
question1
