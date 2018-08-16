#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

### GEN STARTED
bash /opt/plexguide/roles/install/scripts/yml-gen.sh &>/dev/null &

###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
file="/var/plexguide"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   mkdir -p /var/plexguide 1>/dev/null 2>&1
   chown 0755 /var/plexguide 1>/dev/null 2>&1
   chmod 1000:1000 /var/plexguide 1>/dev/null 2>&1
   echo 'INFO - PLexGuide Directory Was Created' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi

file="/opt/appdata/plexguide"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo 'INFO - PlexGuide Directory Was Created' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
   mkdir -p /opt/appdata/plexguide 1>/dev/null 2>&1
   chown 0755 /opt/appdata/plexguide 1>/dev/null 2>&1
   chmod 1000:1000 /opt/appdata/plexguide 1>/dev/null 2>&1
fi

## Create Dummy File on /mnt/gdrive/plexguide
file="/mnt/unionfs/plexguide/pgchecker.bin"
if [ -e "$file" ]
then
   echo 'PASSED - UnionFS is Properly Working - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
else
   mkdir -p /mnt/tdrive/plexguide/ 1>/dev/null 2>&1
   mkdir -p /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
   mkdir -p /tmp/pgchecker/ 1>/dev/null 2>&1
   touch /tmp/pgchecker/pgchecker.bin 1>/dev/null 2>&1
   rclone copy /tmp/pgchecker gdrive:/plexguide/ &>/dev/null &
   rclone copy /tmp/pgchecker tdrive:/plexguide/ &>/dev/null &
   rclone copy /tmp/pgchecker gcrypt:/plexguide/ &>/dev/null &
   rclone copy /tmp/pgchecker tcrypt:/plexguide/ &>/dev/null &
   echo 'INFO - Deployed PGChecker.bin to GDrive - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi

###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
file="/var/plexguide/pgfork.project"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo "UPDATE ME" > /var/plexguide/pgfork.project
fi

file="/var/plexguide/pgfork.version"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   echo "changeme" > /var/plexguide/pgfork.version
fi

file="/var/plexguide/tld.program"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   touch /var/plexguide/tld.program
   echo "portainer" > /var/plexguide/tld.program
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
    echo "no.domain" >> /var/plexguide/server.domain
fi

hostname -I | awk '{print $1}' > /var/plexguide/server.ip
###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - END
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
   echo 'INFO - Installed Dialog' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi

#clear warning messages
for txtfile in certchecker nopassword pingchecker; do
  echo -n '' > /var/plexguide/$txtfile; done

# security scan
bash /opt/plexguide/scripts/startup/pg-auth-scan.sh &
# traefik cert validation
bash /opt/plexguide/scripts/startup/certchecker.sh &

sudo rm -r /opt/plexguide/menus/version/main.sh && sudo mkdir -p /opt/plexguide/menus/version/ && sudo wget --force-directories -O /opt/plexguide/menus/version/main.sh https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Version-6/menus/version/main.sh 1>/dev/null 2>&1
rm -r /opt/plexguide/roles/versions/scripts/ver.list && sudo mkdir -p /opt/plexguide/roles/versions/scripts/ && sudo wget --force-directories -O /opt/plexguide/roles/versions/scripts/ver.list https://raw.githubusercontent.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/Edge/roles/versions/scripts/ver.list 1>/dev/null 2>&1

# copying rclone config to user incase bonehead is not root
cp /root/.config/rclone/rclone.conf ~/.config/rclone/rclone.conf 1>/dev/null 2>&1

# run pg main
bash /opt/plexguide/pg.sh


## Selects an edition
edition=$( cat /var/plexguide/pg.edition )

#### G-Drive Edition
if [ "$edition" == "PG Edition: GDrive" ]
  then
    echo 'INFO - Deploying GDrive Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/roles/menu-start/scripts/main.sh
    exit
fi

#### Multiple Drive Edition
if [ "$edition" == "PG Edition: HD Multi" ]
  then
    echo 'INFO - Deploying Multi HD Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/roles/localmain.sh
    exit
fi

#### Solo Drive Edition
if [ "$edition" == "PG Edition: HD Solo" ]
  then
   echo 'INFO - Deploying HD Solo Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/roles/localmain.sh
    exit
fi

if [ "$edition" == "PG Edition: GCE Feed" ]
  then
   echo 'INFO - Deploying GCE Feeder Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/roles/gce/gcechecker.sh
    bash /opt/plexguide/roles/menu-start/scripts/main.sh
    exit
fi
