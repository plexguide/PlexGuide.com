#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

### GEN STARTED
bash /opt/plexguide/roles/baseline/scripts/gen.sh &>/dev/null &

###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
file="/var/plexguide"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   mkdir -p /var/plexguide 1>/dev/null 2>&1
   chown 0755 /var/plexguide 1>/dev/null 2>&1
   chmod 1000:1000 /var/plexguide 1>/dev/null 2>&1
   echo 'INFO - PLexGuide Directory Was Created' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
fi

file="/opt/appdata/plexguide"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo 'INFO - PlexGuide Directory Was Created' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
   mkdir -p /opt/appdata/plexguide 1>/dev/null 2>&1
   chown 0755 /opt/appdata/plexguide 1>/dev/null 2>&1
   chmod 1000:1000 /opt/appdata/plexguide 1>/dev/null 2>&1
fi

## Create Dummy File on /mnt/gdrive/plexguide
file="/mnt/unionfs/plexguide/pgchecker.bin"
if [ -e "$file" ]
then
   echo 'PASSED - UnionFS is Properly Working - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
else
   mkdir -p /mnt/tdrive/plexguide/ 1>/dev/null 2>&1
   mkdir -p /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
   mkdir -p /tmp/pgchecker/ 1>/dev/null 2>&1
   touch /tmp/pgchecker/pgchecker.bin 1>/dev/null 2>&1
   rclone copy /tmp/pgchecker gdrive:/plexguide/ &>/dev/null &
   rclone copy /tmp/pgchecker tdrive:/plexguide/ &>/dev/null &
   rclone copy /tmp/pgchecker gcrypt:/plexguide/ &>/dev/null &
   rclone copy /tmp/pgchecker tcrypt:/plexguide/ &>/dev/null &
   echo 'INFO - Deployed PGChecker.bin to GDrive - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
fi

###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
file="/var/plexguide/pgfork.project"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo "changeme" > /var/plexguide/pgfork.project
fi

file="/var/plexguide/pgfork.version"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo "changeme" > /var/plexguide/pgfork.version
fi

file="/var/plexguide/tld.tautulli"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.tautulli
fi

file="/var/plexguide/tld.htpcmanager"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.htpcmanager
fi

file="/var/plexguide/tld.muximux"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.muximux
fi

file="/var/plexguide/tld.organizr"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.organizr
fi

file="/var/plexguide/tld.ombi"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.ombi
fi

file="/var/plexguide/tld.heimdall"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.heimdall
fi

file="/opt/appdata/plexguide/plextoken"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /opt/appdata/plexguide/plextoken
fi

file="touch /var/plexguide/server.ht"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/server.ht
fi

file="/var/plexguide/server.email"
if [ -e "$file" ]
  then
    echo "" &>/dev/null &
  else
    echo "changeme@bademail.com" >> /var/plexguide/server.email
fi

file="/var/plexguide/server.domain"
if [ -e "$file" ]
  then
    echo "" &>/dev/null &
  else
    echo "changeme.com" >> /var/plexguide/server.domain
fi

hostname -I | awk '{print $1}' > /var/plexguide/server.ip
###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - END

#### Set Fixed Information
sudo bash /opt/plexguide/roles/info.sh

#### Temp Variables Established To Prevent Crashing - START
echo "plexguide" > /tmp/pushover
#### Temp Variables Esablished  To Prevent Crashing - END

echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
mkdir /var/plexguide/ 1>/dev/null 2>&1

file="/usr/bin/dialog"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   clear
   echo "Installing Dialog"
   apt-get install dialog 1>/dev/null 2>&1
   export NCURSES_NO_UTF8_ACS=1
   echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
   echo 'INFO - Installed Dialog' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
fi
# install pgstatus if needed
[[ ! -e /bin/pgstatus ]] && \
 cp /opt/plexguide/scripts/docker-no/superstatus/pgstatus /bin/pgstatus

#clear warning messages
for txtfile in certchecker nopassword pingchecker; do
  echo -n '' > /var/plexguide/$txtfile; done

# security scan
bash /opt/plexguide/scripts/startup/pg-auth-scan.sh &
# traefik cert validation
bash /opt/plexguide/scripts/startup/certchecker.sh &

sudo rm -r /opt/plexguide/menus/version/main.sh && sudo mkdir -p /opt/plexguide/menus/version/ && sudo wget --force-directories -O /opt/plexguide/menus/version/main.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Version-6/menus/version/main.sh 1>/dev/null 2>&1

# copying rclone config to user incase bonehead is not root
cp /root/.config/rclone/rclone.conf ~/.config/rclone/rclone.conf 1>/dev/null 2>&1

file="/var/plexguide/ubversion"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo 'INFO - Executing UB Version Check Script' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
   bash /opt/plexguide/scripts/ubcheck/main.sh
fi

file="/var/plexguide/ask.yes"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   bash /opt/plexguide/menus/version/main.sh
   echo "SUCCESS - First Time Execution" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
   clear
      echo "1. Please STAR PG via http://github.plexguide.com"
      echo "2. Join the PG Discord via http://discord.plexguide.com"
      echo "3. Donate to PG via http://donate.plexguide.com"
      echo ""
      echo "TIP : Press Z, then [ENTER] in the Menus to Exit"
      echo "TIP : Menu Letters Displayed are HotKeys"
      echo "TIP : Update Plexguide Anytime, type: sudo pgupdate"
      echo "NOTE: Restart the Program Anytime, type: sudo plexguide"
      echo ""
   exit 0
fi

edition=$( cat /var/plexguide/pg.edition )
current=$( cat /var/plexguide/pg.preinstall )
stored=$( cat /var/plexguide/pg.preinstall.stored )
if [ "$current" == "$stored" ]
then
   echo 'INFO - PG BaseInstaller Not Required - Up To Date' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
   touch /var/plexguide/message.no
else
  ############## Executes PG Edition If User Never Selected One
  file="/var/plexguide/pg.edition"
  if [ -e "$file" ]
  then
     bash /opt/plexguide/menus/startup/message2.sh
  else
  echo 'Asking User for PG Edition for the First Time' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
  bash /opt/plexguide/scripts/baseinstall/edition.sh
  fi

  echo 'INFO - PG BaseInstaller Executed' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
  bash /opt/plexguide/roles/baseline/scripts/main.sh
fi

## docker / ansible failure
file="/var/plexguide/startup.error" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
    dialog --title "Docker Failure" --msgbox "\nYour Docker is not installed or has failed\n\n- Most problems are due to using a VPS\n- Using an OutDated Kernel\n- 99% is your VPS provider being SPECIAL\n- A modified version of Ubuntu\n\nTry a Reboot First and RERUN. If it fails, please check with site forums." 0 0
    dialog --infobox "Exiting!" 0 0
    sleep 5
      echo 'FAILURE - Docker Failed To Install' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
      clear
      echo "EXITED DUE TO DOCKER FAILURE!!!!!"
      echo ""
      echo "1. Please STAR PG via http://github.plexguide.com"
      echo "2. Join the PG Discord via http://discord.plexguide.com"
      echo "3. Donate to PG via http://donate.plexguide.com"
      echo ""
      echo "TIP : Press Z, then [ENTER] in the Menus to Exit"
      echo "TIP : Menu Letters Displayed are HotKeys"
      echo "TIP : Update Plexguide Anytime, type: sudo pgupdate"
      echo "NOTE: Restart the Program Anytime, type: sudo plexguide"
      echo ""
    exit
  fi

# checking to see if PG Edition was set
file="/var/plexguide/pg.edition"
if [ -e "$file" ]
then
   bash /opt/plexguide/menus/startup/message2.sh
else
echo 'WARNING - PG Edition Missing (Ask User - Executing Failsafe)' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
bash /opt/plexguide/roles/baseline/scripts/edition.sh
fi

## Selects an edition
edition=$( cat /var/plexguide/pg.edition )

#### G-Drive Edition
if [ "$edition" == "PG Edition: GDrive" ]
  then
    echo 'INFO - Deploying GDrive Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
    bash /opt/plexguide/roles/main.sh
    exit
fi

#### Multiple Drive Edition
if [ "$edition" == "PG Edition: HD Multi" ]
  then
    echo 'INFO - Deploying Multi HD Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
    bash /opt/plexguide/roles/localmain.sh
    exit
fi

#### Solo Drive Edition
if [ "$edition" == "PG Edition: HD Solo" ]
  then
   echo 'INFO - Deploying HD Solo Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
    bash /opt/plexguide/roles/localmain.sh
    exit
fi

if [ "$edition" == "PG Edition: GCE Feed" ]
  then
   echo 'INFO - Deploying GCE Feeder Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
    bash /opt/plexguide/roles/gce.sh
    exit
fi

#### falls to this menu incase none work above
echo 'WARNING - PG Edition Missing (Ask User - Executing Failsafe)' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
bash /opt/plexguide/scripts/baseinstall/edition.sh
