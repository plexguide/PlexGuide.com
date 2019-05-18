#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh

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
croncheck=$(cat /opt/communityapps/apps/_cron.list | grep -c "\<$p\>")
if [ "$croncheck" == "0" ]; then bash /opt/plexguide/menu/cron/cron.sh; fi
}

cronmass () {
croncheck=$(cat /opt/communityapps/apps/_cron.list | grep -c "\<$p\>")
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

  mkdir -p /opt/communityapps


  if [ "$boxversion" == "official" ]; then ansible-playbook /opt/plexguide/menu/pgbox/pgboxcommunity.yml
  else ansible-playbook /opt/plexguide/menu/pgbox/pgbox_communitypersonal.yml; fi

  echo ""
  echo "💬  Pulling Update Files - Please Wait"
  file="/opt/communityapps/place.holder"
  waitvar=0
  while [ "$waitvar" == "0" ]; do
  	sleep .5
  	if [ -e "$file" ]; then waitvar=1; fi
  done
  customcontainers
}

question1 () {

  ### Remove Running Apps
  while read p; do
    sed -i "/^$p\b/Id" /pg/var/app.list
  done </pg/var/pgbox.running

  cp /pg/var/app.list /pg/var/app.list2

  file="/pg/var/community.app"
  #if [ ! -e "$file" ]; then
    ls -la /opt/communityapps/apps | sed -e 's/.yml//g' \
    | awk '{print $9}' | tail -n +4  > /pg/var/app.list
  while read p; do
    echo "" >> /opt/communityapps/apps/$p.yml
    echo "##PG-Community" >> /opt/communityapps/apps/$p.yml

    mkdir -p /opt/mycontainers
    touch /pg/data/blitz/rclone.conf
  done </pg/var/app.list
    touch /pg/var/community.app
  #fi

#bash /opt/communityapps/apps/_appsgen.sh
docker ps | awk '{print $NF}' | tail -n +2 > /pg/var/pgbox.running

### Remove Official Apps
while read p; do
  # reminder, need one for custom apps
  baseline=$(cat /opt/communityapps/apps/$p.yml | grep "##PG-Community")
  if [ "$baseline" == "" ]; then sed -i -e "/$p/d" /pg/var/app.list; fi
done </pg/var/app.list

### Blank Out Temp List
rm -rf /pg/var/program.temp && touch /pg/var/program.temp

### List Out Apps In Readable Order (One's Not Installed)
sed -i -e "/templates/d" /pg/var/app.list
sed -i -e "/image/d" /pg/var/app.list
sed -i -e "/_/d" /pg/var/app.list
num=0
while read p; do
  echo -n $p >> /pg/var/program.temp
  echo -n " " >> /pg/var/program.temp
  num=$[num+1]
  if [[ "$num" == "7" ]]; then
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

if [[ "$typed" == "deploy" ]]; then question2; fi

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

bash /opt/communityapps/apps/image/_image.sh
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
ansible-playbook /opt/communityapps/apps/$p.yml

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

pinterface () {

boxuser=$(cat /pg/var/boxcommunity.user)
boxbranch=$(cat /pg/var/boxcommunity.branch)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Community Box Edition!         📓 Reference: community.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 User: $boxuser | Branch: $boxbranch

[1] Change User Name & Branch
[2] Deploy Community Box - Personal (Forked)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 IMPORTANT MESSAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Username & Branch are both case sensitive! Normal default branch is v8,
but check the branch under your fork that is being pulled!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -p 'Username | Press [ENTER]: ' boxuser < /dev/tty
        read -p 'Branch   | Press [ENTER]: ' boxbranch < /dev/tty
        echo "$boxuser" > /pg/var/boxcommunity.user
        echo "$boxbranch" > /pg/var/boxcommunity.branch
        pinterface ;;
    2 )
        existcheck=$(git ls-remote --exit-code -h "https://github.com/$boxuser/Apps-Community" | grep "$boxbranch")
        if [ "$existcheck" == "" ]; then echo;
        read -p '💬 Exiting! Forked Version Does Not Exist! | Press [ENTER]: ' typed < /dev/tty
        mainbanner; fi

        boxversion="personal"
        initial
        question1 ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

mainbanner () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Community Box Edition!         📓 Reference: community.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 Community Box apps simplify their usage within PGBlitz! PG provides more
focused support and development based on community usage.

💬 The Personal Forked option will install your version of Community Box. Good
for testing or for personal mods! Ensure that it exist prior to use!

[1] Utilize Community Box - PGBlitz's
[2] Utilize Community Box - Personal (Forked)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p 'Type a Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        boxversion="official"
        initial
        question1 ;;
    2 )
        variable /pg/var/boxcommunity.user "NOT-SET"
        variable /pg/var/boxcommunity.branch "NOT-SET"
        pinterface ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        mainbanner ;;
esac
}

# FUNCTIONS END ##############################################################
echo "" > /pg/tmp/output.info
mainbanner
