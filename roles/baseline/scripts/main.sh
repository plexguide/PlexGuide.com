echo "INFO - BaseInstall Started" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
edition=$( cat /var/plexguide/pg.edition )
############################################################ Basic Menu

edition=$( cat /var/plexguide/pg.edition )
######### Check to SEE IF GCE FEED Edition
if [ "$edition" == "PG Edition: GCE Feed" ]
  then
      touch /var/plexguide/server.appguard 1>/dev/null 2>&1
      echo "[OFF]" > /var/plexguide/server.appguard
      touch /var/plexguide/server.ports
      echo "[OPEN]" > /var/plexguide/server.ports.status
  else
    #### If NOT GCE Edition
    file="/var/plexguide/server.settings.set" 1>/dev/null 2>&1
      if [ -e "$file" ]
        then
          echo "" 1>/dev/null 2>&1
        else
          echo "INFO - Selecting PG Edition for the FIRST TIME" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
          bash /opt/plexguide/menus/setup/servertype.sh
    fi
    file="/var/plexguide/server.ports" 1>/dev/null 2>&1
      if [ -e "$file" ]
        then
      echo "" 1>/dev/null 2>&1
        else
      touch /var/plexguide/server.ports
      echo "[OPEN]" > /var/plexguide/server.ports.status
      fi

      file="/var/plexguide/server.appguard" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
        echo "" 1>/dev/null 2>&1
          else
        touch /var/plexguide/server.appguard 1>/dev/null 2>&1
        echo "[OFF]" > /var/plexguide/server.appguard
        fi
fi

############################################################ Starting Install Processing

echo "80" | dialog --gauge "Installing: AutoDelete & Cleaner" 7 50 0
ansible-playbook /opt/plexguide/pg.yml --tags autodelete &>/dev/null &
ansible-playbook /opt/plexguide/pg.yml --tags clean &>/dev/null &
ansible-playbook /opt/plexguide/pg.yml --tags clean-encrypt &>/dev/null &
sleep 2

#### Install Alias Command - 85 Percent
bash /opt/plexguide/roles/baseline/scripts/portainer.sh

############################################################ Reboot Startup Container Script
pg_docstart=$( cat /var/plexguide/pg.docstart)
pg_docstart_stored=$( cat /var/plexguide/pg.docstart.stored )

echo "90" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
#sleep 2

#### Install WatchTower Command - 95 Percent
bash /opt/plexguide/roles/baseline/scripts/watchtower.sh
