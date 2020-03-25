#!/bin/bash
# URL:        PlexGuide.com / PGBlitz.com
# GNU:        General Public License v3.0
################################################################################

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

}
backupex() {
  time=$(date +%Y-%m-%d-%H:%M:%S)
  mkdir -p /var/backup-pg/
  tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /opt/plexguide -cf /var/backup-pg/plexguide-old-"$time".tar.gz ./
  tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /pg/var -cf /var/backup-pg/var-plexguide-old-"$time".tar.gz ./

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
if [[ -e "/pg/var" ]]; then rm -rf /pg/var; fi
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
##############################
base() {

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Base Install - Standby  || This may take a few minuets. Grab a Coffee!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

######################
repo() {

}
##############################
#####
editionpg() {
echo -ne '                         (0%)\r'
# Delete If it Exist for Cloning
if [[ -e "/opt/plexguide" ]]; then rm -rf /opt/plexguide; fi
if [[ -e "/opt/pgstage" ]]; then rm -rf /opt/pgstage; fi
echo -ne '###                      (10%)\r'
if [[ -e "/pg/var" ]]; then rm -rf /pg/var; fi
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
mkdir -p /pg/var/logs
echo "" >/pg/var/server.ports
echo "51" >/pg/var/pg.pythonstart
echo -ne '############              (50%)\r'
touch /pg/var/pg.pythonstart.stored
start=$(cat /pg/var/pg.pythonstart)
stored=$(cat /pg/var/pg.pythonstart.stored)
echo -ne '###############            (60%)\r'
if [[ "$start" != "$stored" ]]; then bash /opt/pgstage/pyansible.sh 1>/dev/null 2>&1; fi
echo -ne '####################       (70%)\r'
echo "51" >/pg/var/pg.pythonstart.stored
pip install --upgrade pip 1>/dev/null 2>&1


################ ansible-playbook /opt/pgstage/clone.yml
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
touch /pg/var/new.install
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
touch /pg/var/new.install
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
