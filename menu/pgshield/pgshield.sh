#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh

question1 () {

domaincheck=$(cat /var/plexguide/server.domain)
touch /var/plexguide/server.domain
touch /tmp/portainer.check
rm -r /tmp/portainer.check
wget -q "https://portainer.${domaincheck}" -O /tmp/portainer.check
domaincheck=$(cat /tmp/portainer.check)
if [ "$domaincheck" == "" ]; then
echo
echo "💬  Unable to reach your Subdomain for Portainer!"
echo ""
echo "1. Forget to enable Traefik?"
echo "2. Valdiate if Subdomain is Working?"
echo "3. Validate Portainer is Deployed?"
echo ""
read -p 'Confirm Info | Press [ENTER]: ' typed < /dev/tty
exit; fi

touch /var/plexguide/pgshield.emails
mkdir -p /var/plexguide/auth/

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Shield                       ⚡ Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  PG Shield requires Google Web Auth Keys! Visit the link above!

1. Set Web Client ID & Secret
2. Authorize User(s)
3. Exempt PG Apps
4. Deploy PG Shiled
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
phase1
}

phase1 () {

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        webid
        phase1 ;;
    2 )
        email
        phase1 ;;
    3 )
        appexempt
        phase1 ;;
    4 )
        touch /var/plexguide/pgshield.compiled
        rm -r /var/plexguide/pgshield.compiled
        while read p; do
          echo -n "$p," >> /var/plexguide/pgshield.compiled
        done </var/plexguide/pgshield.emails

        ansible-playbook /opt/plexguide/menu/pgshield/pgshield.yml
        phase1 ;;
    z )
        exit ;;
    Z )
        exit ;;
    * )
        question1 ;;
esac
}

appexempt() {
bash /opt/plexguide/containers/_appsgen.sh
ls -l /var/plexguide/auth | awk '{ print $9 }' > /var/plexguide/pgshield.ex15

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Shield - App Exemption        ⚡ Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Application: Exempt
2. Application: Protect Again
3. Application: Protect All Apps (Reset)
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
phase3
}

phase3() {
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        phase31
        appexempt ;;
    2 )
        phase21
        appexempt ;;
    3 )
        rm -rf /var/plexguide/auth/*
        echo ""
        echo "NOTE: Does Not Take Effect Until PG Shield is Redeployed!"
        read -p 'Acknowledge Info | Press [ENTER] ' typed < /dev/tty; email
        appexempt;;
    z )
        question1 ;;
    Z )
        question1 ;;
    * )
        appexempt ;;
esac

}

phase31(){
  touch /var/plexguide/app.list
  while read p; do
    sed -i -e "/$p/d" /var/plexguide/app.list
  done </var/plexguide/pgshield.ex15

  ### Blank Out Temp List
  rm -rf /var/plexguide/program.temp && touch /var/plexguide/program.temp

  ### List Out Apps In Readable Order (One's Not Installed)
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

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Shield - App Exemption         📓 Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Potential Apps to Exempt

$notrun

💬 Quitting? TYPE > exit
EOF
  read -p '🌍 Type APP to Exempt | Press [ENTER]: ' typed < /dev/tty

grep -w "$typed" /var/plexguide/program.temp > /var/plexguide/check55.sh
usercheck=$(cat /var/plexguide/check55.sh)

if [[ "$usercheck" == "" ]]; then echo;
read -p 'App Does Not Exist! | Press [ENTER] ' note < /dev/tty; appexempt; fi

touch /var/plexguide/auth/$typed
echo
echo "NOTE: No Effect until PG Shield or the App Solo is Redeployed!"
read -p '🌍 Acknoweldge! | Press [ENTER] ' note < /dev/tty; appexempt
}

phase21(){

  ### Blank Out Temp List
  rm -rf /var/plexguide/program.temp && touch /var/plexguide/program.temp

  ### List Out Apps In Readable Order (One's Not Installed)
  num=0
  while read p; do
    echo -n $p >> /var/plexguide/program.temp
    echo -n " " >> /var/plexguide/program.temp
    num=$[num+1]
    if [ "$num" == 7 ]; then
      num=0
      echo " " >> /var/plexguide/program.temp
    fi
  done </var/plexguide/pgshield.ex15

  notrun=$(cat /var/plexguide/program.temp)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Shield - App Protect Restore   📓 Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Potential Apps to Restore

$notrun

💬 Quitting? TYPE > exit
EOF
  read -p '🌍 Type APP to Restore | Press [ENTER]: ' typed < /dev/tty

grep -w "$typed" /var/plexguide/pgshield.ex15 > /var/plexguide/check55.sh
usercheck=$(cat /var/plexguide/check55.sh)

if [[ "$usercheck" == "" ]]; then echo;
read -p 'App Does Not Exist! | Press [ENTER] ' note < /dev/tty; appexempt; fi

touch /var/plexguide/auth/$typed
echo
echo "NOTE: No Effect until PG Shield or the App Solo is Redeployed!"
read -p '🌍 Acknoweldge! | Press [ENTER] ' note < /dev/tty; appexempt
}

webid() {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Web Keys - Client ID       📓 Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google Web Auth Keys

EOF

read -p '↘️  Web Client ID     | Press [Enter]: ' public < /dev/tty
if [ "$public" = "exit" ]; then exit; fi
echo "$public" > /var/plexguide/shield.clientid

read -p '↘️  Web Client Secret | Press [Enter]: ' secret < /dev/tty
if [ "$secret" = "exit" ]; then exit; fi
echo "$secret" > /var/plexguide/shield.clientsecret

read -p '🌎 Client ID & Secret Set |  Press [ENTER] ' public < /dev/tty
question1
}

email() {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PG Shield - Trusted Users        ⚡ Reference: pgshield.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. E-Mail: Add User
2. E-Mail: Remove User
3. E-Mail: View Authorization List
4. E-Mail: Remove All Users (Stops PG Shield)
Z. EXIT

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
phase2
}

phase2 () {

read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
        echo
        read -p 'User Email to Add | Press [ENTER]: ' typed < /dev/tty

        emailcheck=$(echo $typed | grep "@")
        if [[ "$emailcheck" == "" ]]; then
          read -p 'Invalid E-Mail! | Press [ENTER] ' note < /dev/tty; email; fi

        usercheck=$(cat /var/plexguide/pgshield.emails | grep $typed )
        if [[ "$usercheck" != "" ]]; then
          read -p 'User Already Exists! | Press [ENTER] ' note < /dev/tty; email; fi
          read -p 'User Added | Press [ENTER] ' note < /dev/tty;
        echo "$typed" >> /var/plexguide/pgshield.emails
        email ;;
    2 )
        echo
        read -p 'User Email to Remove | Press [ENTER]: ' typed < /dev/tty
        testremove=$(cat /var/plexguide/pgshield.emails | grep $typed )
        if [[ "$testremove" == "" ]]; then
        read -p 'User Does Not Exist | Press [ENTER] ' typed < /dev/tty; email; fi
        sed -i -e "/$typed/d" /var/plexguide/pgshield.emails
        echo ""
        echo "NOTE: Does Not Take Effect Until PG Shield is Redeployed!"
        read -p 'Removed User | Press [ENTER] ' typed < /dev/tty; email
        email ;;
    3 )
        echo
        echo "Current Authorized E-Mail Addresses"
        echo ""
        cat /var/plexguide/pgshield.emails
        echo
        read -p 'Finished? | Press [ENTER] ' typed < /dev/tty; email
        email ;;
    4 )
        test=$(cat /var/plexguide/pgshield.emails | grep "@")
        if [[ "$test" == "" ]]; then email; fi
        docker stop oauth
        rm -r /var/plexguide/pgshield.emails
        touch /var/plexguide/pgshield.emails
        echo
        docker stop oauth
        read -p 'All Prior Users Removed! | Press [ENTER] ' typed < /dev/tty
        email ;;
    z )
        question1 ;;
    Z )
        question1 ;;
    * )
        email ;;
esac
}

question1
