#!/bin/bash



file="touch /var/plexguide/server.ht"
if [ ! -e "$file" ]; then
   touch /var/plexguide/server.ht
fi

file="/var/plexguide/server.email"
if [ ! -e "$file" ]; then
    echo "changeme@bademail.com" >> /var/plexguide/server.email
fi

file="/var/plexguide/server.domain"
if [ ! -e "$file" ]; then
    echo "no.domain" >> /var/plexguide/server.domain
fi

hostname -I | awk '{print $1}' > /var/plexguide/server.ip
###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - END
echo "export NCURSES_NO_UTF8_ACS=1" >> /etc/bash.bashrc.local
mkdir /var/plexguide/ 1>/dev/null 2>&1

#clear warning messages
for txtfile in certchecker nopassword pingchecker; do
  echo -n '' > /var/plexguide/$txtfile; done

# security scan
bash /opt/plexguide/menu/scripts/startup/pg-auth-scan.sh &
# traefik cert validation
bash /opt/plexguide/menu/scripts/startup/certchecker.sh &

# copying rclone config to user incase bonehead is not root
cp /opt/appdata/plexguide/rclone.conf ~/.config/rclone/rclone.conf 1>/dev/null 2>&1

# run pg main
bash /opt/plexguide/pg.sh
file="/var/plexguide/update.failed"
if [ -e "$file" ]; then
  rm -rf /var/plexguide/update.failed
  exit
fi

## Selects an edition
touch /var/plexguide/pg.edition
edition=$( cat /var/plexguide/pg.edition )

if [ "$edition" == "PG Edition - GDrive" ]; then
    bash /opt/plexguide/menu/start/start.sh
    exit
elif [ "$edition" == "PG Edition - HD Multi" ]; then
    bash /opt/plexguide/menu/start/start.sh
    exit
elif [ "$edition" == "PG Edition - HD Solo" ]; then
    bash /opt/plexguide/menu/start/start.sh
    exit
elif [ "$edition" == "PG Edition - GCE Feed" ]; then
    bash /opt/plexguide/menu/interface/gce/gcechecker.sh
    bash /opt/plexguide/menu/start/start.sh
    exit
else
    file="/var/plexguide/pg.preinstall.stored"
    if [ -e "$file" ]; then
      touch /var/plexguide/pg.edition
      bash /opt/plexguide/menu/interface/install/scripts/edition.sh
      bash /opt/plexguide/pg.sh
      bash /opt/plexguide/menu/start/start.sh
    else
      bash /opt/plexguide/menu/start/start.sh
    fi
fi
