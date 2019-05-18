#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

queued () {
echo
read -p '⛔️ ERROR - APP Already Queued! | Press [ENTER] ' typed < /dev/tty
question1
}

exists () {
echo ""
echo "⛔️ ERROR - APP Already Installed!"
read -p '⚠️  Do You Want To ReInstall ~ y or n | Press [ENTER] ' foo < /dev/tty

if [ "$foo" == "y" ]; then part1;
elif [ "$foo" == "n" ]; then question1;
else exists; fi
}

cronexe () {
croncheck=$(cat /opt/coreapps/apps/_cron.list | grep -c "\<$p\>")
if [ "$croncheck" == "0" ]; then bash /opt/plexguide/menu/cron/cron.sh; fi
}

cronmass () {
croncheck=$(cat /opt/coreapps/apps/_cron.list | grep -c "\<$p\>")
if [ "$croncheck" == "0" ]; then bash /opt/plexguide/menu/cron/cron.sh; fi
}

initial () {
  rm -rf /pg/var/pgbox.output 1>/dev/null 2>&1
  rm -rf /pg/var/pgbox.buildup 1>/dev/null 2>&1
  rm -rf /pg/var/program.temp 1>/dev/null 2>&1
  rm -rf /pg/var/app.list 1>/dev/null 2>&1
  touch /pg/var/pgbox.output
  touch /pg/var/program.temp
  touch /pg/var/app.list
  touch /pg/var/pgbox.buildup

  bash /opt/coreapps/apps/_appsgen.sh
  docker ps | awk '{print $NF}' | tail -n +2 > /pg/var/pgbox.running
}
# FIRST QUESTION

question1 () {

### Remove Running Apps
while read p; do
  sed -i "/^$p\b/Id" /pg/var/app.list
done </pg/var/pgbox.running

### Blank Out Temp List
rm -rf /pg/var/program.temp && touch /pg/var/program.temp

### List Out Apps In Readable Order (One's Not Installed)
sed -i -e "/templates/d" /pg/var/app.list
touch /pg/tmp/test.99
num=0
while read p; do
  echo -n $p >> /pg/var/program.temp
  echo -n " " >> /pg/var/program.temp
  num=$[num+1]
  if [ "$num" == 7 ]; then
    num=0
    echo " " >> /pg/var/program.temp
  fi
done </pg/var/app.list

notrun=$(cat /pg/var/program.temp)
buildup=$(cat /pg/var/pgbox.output)

if [ "$buildup" == "" ]; then buildup="NONE"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PGBox ~ Multi-App Installer           📓 Reference: pgbox.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Potential Apps to Install

$notrun

💾 Apps Queued for Installation

$buildup

💬 Quitting? TYPE > exit | 💪 Ready to install? TYPE > deploy
EOF
read -p '🌍 Type APP for QUEUE | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "deploy" ]; then question2; fi

if [ "$typed" == "exit" ]; then exit; fi

current=$(cat /pg/var/pgbox.buildup | grep "\<$typed\>")
if [ "$current" != "" ]; then queued && question1; fi

current=$(cat /pg/var/pgbox.running | grep "\<$typed\>")
if [ "$current" != "" ]; then exists && question1; fi

current=$(cat /pg/var/program.temp | grep "\<$typed\>")
if [ "$current" == "" ]; then badinput1 && question1; fi

part1
}

part1 () {
echo "$typed" >> /pg/var/pgbox.buildup
num=0

touch /pg/var/pgbox.output && rm -rf /pg/var/pgbox.output

while read p; do
echo -n $p >> /pg/var/pgbox.output
echo -n " " >> /pg/var/pgbox.output
if [ "$num" == 7 ]; then
  num=0
  echo " " >> /pg/var/pgbox.output
fi
done </pg/var/pgbox.buildup

sed -i "/^$typed\b/Id" /pg/var/app.list

question1
}

final () {
  read -p '✅ Process Complete! | PRESS [ENTER] ' typed < /dev/tty
  echo
  exit
}

question2 () {

# Image Selector
image=off
while read p; do

echo $p > /pg/tmp/program_var

bash /opt/coreapps/apps/image/_image.sh
done </pg/var/pgbox.buildup

# Cron Execution
edition=$( cat /pg/var/pg.edition )
if [[ "$edition" == "PG Edition - HD Solo" ]]; then a=b
else
  croncount=$(sed -n '$=' /pg/var/pgbox.buildup)
  echo "false" > /pg/var/cron.count
  if [ "$croncount" -ge "2" ]; then bash /opt/plexguide/menu/cron/mass.sh; fi
fi


while read p; do
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$p - Now Installing!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 2.5

if [ "$p" == "plex" ]; then bash /opt/plexguide/menu/plex/plex.sh;
elif [ "$p" == "nzbthrottle" ]; then nzbt; fi

# Store Used Program
echo $p > /pg/tmp/program_var
# Execute Main Program
ansible-playbook /opt/coreapps/apps/$p.yml

if [[ "$edition" == "PG Edition - HD Solo" ]]; then a=b
else if [ "$croncount" -eq "1" ]; then cronexe; fi; fi

# End Banner
bash /opt/plexguide/menu/pgbox/endbanner.sh >> /pg/tmp/output.info

sleep 2
done </pg/var/pgbox.buildup
echo "" >> /pg/tmp/output.info
cat /pg/tmp/output.info
final
}

# FUNCTIONS END ##############################################################
echo "" > /pg/tmp/output.info
initial
question1
