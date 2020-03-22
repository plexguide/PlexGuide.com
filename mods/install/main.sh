#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

## Simple Clone Process
mkdir -p /pg/tmp
rm -rf /pg/mods
rm -rf /pg/tmp/checkout
git clone -b alpha --single-branch https://github.com/PGBlitz/PGBlitz.com.git /pg/tmp/checkout
mv -f /pg/tmp/checkout/mods /pg

## Create & Establish Functions Process
bash /pg/mods/functions/.create.sh
source /pg/mods/functions/.master.sh
################################################################################

install_sudocheck
install_agree

echo "HALTED"
sleep 90


timer() {
seconds=90; date1=$((`date +%s` + $seconds));
while [ "$date1" -ge `date +%s` ]; do
  echo -ne "$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
done
}
existpg() {
file="/opt/plexguide/menu/pg.yml"
  if [[ -f $file ]]; then
	overwrittingpg
  else nopg ; fi
}
overwrittingpg() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ We found an existing PG/PG installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
What would you like to do now? Select from the two option below.

[ Y ] Yes, I want a clean PG installation. (Recommended)
( This will create a backup from 2 folders )

[ N ] No, I want to keep my PG/PG installation
( This has known to cause a lot of problems with PG. Can break PG and PG. )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ Z ] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Y | N or Z | Press [ENTER]: ' typed </dev/tty

  case $typed in
    Y) ovpgex ;;
    y) ovpgex ;;
    N) nope ;;
    n) nope ;;
    z) exit 0 ;;
    Z) exit 0 ;;
    *) badinput1 ;;
  esac
}
nopg() {
 base && repo && packlist && editionpg && value && endingnonexist
}
ovpgex() {
 backupex && base && repo && packlist && editionpg && value && endingexist
}
nope() {
 echo
  exit 0
}
drivecheck() {
  leftover=$(df / --local | tail -n +2 | awk '{print $4}')
  if [[ "$leftover" -lt "50000000" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ WOAH! PG noticed your current system has less then 50GB drive space !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We have recognized less than 50GB of storage space,
this can lead to problems.

Please make sure that there is enough space available.

Moving forward you're carry out this installation at your own risk.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
doneokay
fi
}
doneokay() {
 echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
}
backupex() {
  time=$(date +%Y-%m-%d-%H:%M:%S)
  mkdir -p /var/backup-pg/
  tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /opt/plexguide -cf /var/backup-pg/plexguide-old-"$time".tar.gz ./
  tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /var/plexguide -cf /var/backup-pg/var-plexguide-old-"$time".tar.gz ./

printfiles=$(ls -ah /var/backup-pg/ | grep -E 'plex')
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Backup existing PG / PG installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG made a backup of an existing PG / PG installation for you!

$printfiles
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
doneokay
if [[ -e "/opt/plexguide" ]]; then rm -rf /opt/plexguide; fi
if [[ -e "/opt/pgstage" ]]; then rm -rf /opt/pgstage; fi
if [[ -e "/var/plexguide" ]]; then rm -rf /var/plexguide; fi
if [[ -e "/opt/pgupdate" ]]; then rm -rf /opt/pgudate; fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Cleanup existing PG / PG installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PG has now carried out a cleanup for different needed folders!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
doneokay
}
badinput1() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
  overwrittingpg
}
### FUNCTIONS END #####################################################
### everything after this line belongs to the installer
### INSTALLER FUNCTIONS START #####################################################
mainstart() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLING: PlexGuide.com Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By installing, you are agreeing to the terms and conditions of the GNUv3
License!

Standing By...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
}
##############################
base() {
##check for open port ( apache and Nginx test )
base_list="lsof lsb-release software-properties-common"

apt-get install $base_list -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ PG is checking for existing active Webserver(s) - Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        service apache2 stop >/dev/null 2>&1
        service nginx stop >/dev/null 2>&1
        apt-get purge apache nginx -yqq >/dev/null 2>&1
        apt-get autoremove -yqq >/dev/null 2>&1
        apt-get autoclean -yqq >/dev/null 2>&1
elif lsof -Pi :443 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        service apache2 stop >/dev/null 2>&1
        service nginx stop >/dev/null 2>&1
        apt-get purge apache nginx -yqq >/dev/null 2>&1
        apt-get autoremove -yqq >/dev/null 2>&1
        apt-get autoclean -yqq >/dev/null 2>&1
else echo "" ; fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! PG check for existing Webserver(s) This is now completed !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Base Install - Standby  || This may take a few minuets. Grab a Coffee!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
versioncheck=$(cat /etc/*-release | grep "Ubuntu" | grep -E '19')
  if [[ "$versioncheck" == "19" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ WOAH! ......  System OS Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.* / 10

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  exit 0
  else echo ""; fi
}
######################
repo() {
# add repo
rm -f /var/log/osname.log
touch /var/log/osname.log
echo -e "$(lsb_release -si)" >/var/log/osname.log

if [[ $(lsb_release -si) == "Debian" ]]; then
	add-apt-repository main >/dev/null 2>&1
	add-apt-repository non-free >/dev/null 2>&1
	add-apt-repository contrib >/dev/null 2>&1
	wget -qN https://raw.githubusercontent.com/MHA-Team/Install/master/source/ansible-debian-ansible.list /etc/apt/sources.list.d/
elif [[ $(lsb_release -si) == "Ubuntu" ]]; then
	add-apt-repository main >/dev/null 2>&1
	add-apt-repository universe >/dev/null 2>&1
	add-apt-repository restricted >/dev/null 2>&1
	add-apt-repository multiverse >/dev/null 2>&1
    apt-add-repository --yes --update ppa:ansible/ansible >/dev/null 2>&1
elif [[ $(lsb_release -si) == "Rasbian" || $(lsb_release -si) == "Fedora" || $(lsb_release -si) == "CentOS" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ WOAH! ......  PG System Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.*

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  exit 0
fi
}
##############################
packlist() {
package_list="curl wget software-properties-common git zip unzip dialog sudo nano htop mc lshw ansible fortune intel-gpu-tools python-apt lolcat figlet"
echo -ne '                         (0%)\r'
apt-get update -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
echo -ne '#####                    (20%)\r'
apt-get upgrade -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
apt-get dist-upgrade -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
echo -ne '##########                (40%)\r'
apt-get autoremove -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
echo -ne '###############            (60%)\r'
apt-get install $package_list -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
echo -ne '####################       (80%)\r'
apt-get purge unattended-upgrades -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
echo -ne '#########################    (100%)\r'
echo -ne '\n'
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED - PG finished updating your system!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
#####
editionpg() {
echo -ne '                         (0%)\r'
# Delete If it Exist for Cloning
if [[ -e "/opt/plexguide" ]]; then rm -rf /opt/plexguide; fi
if [[ -e "/opt/pgstage" ]]; then rm -rf /opt/pgstage; fi
echo -ne '###                      (10%)\r'
if [[ -e "/var/plexguide" ]]; then rm -rf /var/plexguide; fi
if [[ -e "/opt/pgupdate" ]]; then rm -rf /opt/pgudate; fi
echo -ne '#####                    (20%)\r'
rm -rf /opt/pgstage/place.holder >/dev/null 2>&1
##fast change the editions
edition=master
##fast change the editions
echo -ne '#######                   (30%)\r'
git clone -b $edition --single-branch https://github.com/MHA-Team/Install.git /opt/pgstage 1>/dev/null 2>&1
git clone https://github.com/MHA-Team/PG-Update.git /opt/pgupdate 1>/dev/null 2>&1
echo -ne '##########                (40%)\r'
mkdir -p /var/plexguide/logs
echo "" >/var/plexguide/server.ports
echo "51" >/var/plexguide/pg.pythonstart
echo -ne '############              (50%)\r'
touch /var/plexguide/pg.pythonstart.stored
start=$(cat /var/plexguide/pg.pythonstart)
stored=$(cat /var/plexguide/pg.pythonstart.stored)
echo -ne '###############            (60%)\r'
if [[ "$start" != "$stored" ]]; then bash /opt/pgstage/pyansible.sh 1>/dev/null 2>&1; fi
echo -ne '####################       (70%)\r'
echo "51" >/var/plexguide/pg.pythonstart.stored
pip install --upgrade pip 1>/dev/null 2>&1
ansible-playbook /opt/pgstage/folders/folder.yml
ansible-playbook /opt/pgstage/clone.yml
echo -ne '####################       (80%)\r'
ansible-playbook /opt/plexguide/menu/alias/alias.yml
ansible-playbook /opt/plexguide/menu/motd/motd.yml
echo -ne '######################     (90%)\r'
ansible-playbook /opt/plexguide/menu/pg.yml --tags journal,system
ansible-playbook /opt/plexguide/menu/pg.yml --tags rcloneinstall
ansible-playbook /opt/plexguide/menu/pg.yml --tags mergerfsinstall
ansible-playbook /opt/plexguide/menu/pg.yml --tags update
echo -ne '#########################  (100%)\r'
echo -ne '\n'
}
############
value() {
if [[ -e "/bin/pg" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  PG is now verifiying it's Install @ /bin/pg - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔            WARNING! PG Installer Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We are happy to do this for you again automatically
We are doing this to ensure that your installation continues to work!
Please wait one moment, while PG now checks and set everything up for you!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
    sudocheck && base && repo && packlist && editionpg && value && ending
fi
}

endingnonexist() {
logfile=/var/log/log-install.txt
chk=$(figlet "<<< M H A - TEAM >>>" | lolcat)
touch /var/plexguide/new.install
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ PASSED ! PG-Team is now Installed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Operations System    : $(lsb_release -sd)
✅ PASSED ! Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
✅ PASSED ! CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
✅ PASSED ! IP from Server       : $(hostname -I | awk '{print $1}')
✅ PASSED ! HDD Space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
✅ PASSED ! RAM Space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
✅ PASSED ! Logfile              : $logfile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> sudo pg
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Want to add an USER with UID 1000 then type >>> sudo pgadd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
###############
endingexist() {
logfile=/var/log/log-install.txt
chk=$(figlet "<<< M H A - TEAM >>>" | lolcat)
touch /var/plexguide/new.install
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ PASSED ! PG-Team is now Installed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Operations System    : $(lsb_release -sd)
✅ PASSED ! Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
✅ PASSED ! CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
✅ PASSED ! IP from Server       : $(hostname -I | awk '{print $1}')
✅ PASSED ! HDD Space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
✅ PASSED ! RAM Space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
✅ PASSED ! PG/PG Backup        : /var/backup-pg/
✅ PASSED ! Logfile              : $logfile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> sudo pg
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Want to add an USER with UID 1000 then type >>> sudo pgadd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
### INSTALLER FUNCTIONS END #####################################################
#### function layout for order one by one

mainstart
sudocheck
drivecheck
existpg
