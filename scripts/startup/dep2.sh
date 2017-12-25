clear

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Installer/Upgrader" --yesno "Do You Agree to Install / Upgrade PlexGuide?" 8 78) then

###################### Install Depdency Programs ###############

    clear
    echo "System Update"
    yes | apt-get update 1>/dev/null 2>&1
    echo "Software Properties Common"
    yes | apt-get install software-properties-common 1>/dev/null 2>&1
    yes | apt-add-repository ppa:ansible/ansible 1>/dev/null 2>&1
    echo "Install Ansible Playbook"
    yes | apt-get install ansible
    echo "Installing Dependicies - Please Wait"
    echo
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags preinstall

    echo ""
    echo "1. Installing Supporting Programs - Directories & Permissions (Please Wait)"

## Create Directory Structure - Goal is to move everything here

################### chown

  chown -R 1000:1000 /opt/plexguide/scripts/docker-no/* 1>/dev/null 2>&1

################### For PlexDrive

  mkdir -p /opt/plexguide-startup 1>/dev/null 2>&1
  chmod 755 /opt/plexguide-startup 1>/dev/null 2>&1

################### For SAB

  mkdir -p /mnt
  mkdir -p /mnt/sab/admin
  mkdir -p /mnt/sab/incomplete
  mkdir -p /mnt/sab/complete/tv
  mkdir -p /mnt/sab/complete/movies
  mkdir -p /mnt/sab/nzb

#################### For NZBGET

  mkdir -p /mnt/nzbget
  mkdir -p /mnt/nzbget/incomplete
  mkdir -p /mnt/nzbget/completed/tv
  mkdir -p /mnt/nzbget/completed/movies
  mkdir -p /mnt/nzbget/nzb
  mkdir -p /mnt/nzbget/tmp
  mkdir -p /mnt/nzbget/queue

########################################################### RClone

mkdir -p /mnt/move
mkdir -p /mnt/gdrive
mkdir -p /mnt/unionfs
mkdir -p /mnt/plexdrive4
mkdir -p /opt/appdata/plexguide
mkdir -p /mnt/plexdrive4

bash /opt/plexguide/scripts/startup/owner.sh 1>/dev/null 2>&1
######################################################### For RCLONE

echo "2. Pre-Installing RClone & Services (Please Wait)"

#Installing RClone and Service
  bash /opt/plexguide/scripts/startup/rclone-preinstall.sh 1>/dev/null 2>&1

#Lets the System Know that Script Ran Once
  touch /var/plexguide/basics.yes 1>/dev/null 2>&1
  touch /var/plexguide/version.5 1>/dev/null 2>&1

echo "3. Pre-Installing PlexDrive & Services (Please Wait)"

#Installing MongoDB for PlexDrive
  bash /opt/plexguide/scripts/startup/plexdrive-preinstall.sh 1>/dev/null 2>&1

#  Adding basic environment file ################################
#  chmod +x bash /opt/plexguide/scripts/basic-env.sh

#  bash /opt/plexguide/scripts/test/basic-env.sh 1>/dev/null 2>&1

  echo "4. Installing Docker & Docker Compose (Please Standby)"

# Install Docker and Docker Composer / Checks to see if is installed also
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose 1>/dev/null 2>&1

  echo "5. Installing Portainer for Docker (Please Wait)"

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d 1>/dev/null 2>&1

############################################# Install a Post-Docker Fix ###################### START

    echo "6. Finishing Up"

tee "/opt/plexguide/scripts/dockerfix.sh" > /dev/null <<EOF
  #!/bin/bash
  sleep 30
  while true
  do
    docker restart emby 1>/dev/null 2>&1
    docker restart nzbget 1>/dev/null 2>&1
    docker restart radarr 1>/dev/null 2>&1
    docker restart sonarr 1>/dev/null 2>&1
    docker restart plexpass 1>/dev/null 2>&1
    docker restart plexpublic 1>/dev/null 2>&1
    docker restart sabnzbd 1>/dev/null 2>&1
  sleep 6000000000000000000000000
  done
EOF

  chmod 755 /opt/plexguide/scripts/dockerfix.sh

## Create the Post-Docker Fix Service
tee "/etc/systemd/system/dockerfix.service" > /dev/null <<EOF
    [Unit]
    Description=Move Service Daemon
    After=multi-user.target
    [Service]
    Type=simple
    User=root
    Group=root
    ExecStart=/bin/bash /opt/plexguide/scripts/dockerfix.sh
    TimeoutStopSec=20
    KillMode=process
    RemainAfterExit=yes
    Restart=always
    [Install]
    WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable dockerfix 1>/dev/null 2>&1
  systemctl start dockerfix 1>/dev/null 2>&1

  echo "7. Rebooting Any Running Containers - Assist UnionFS (Please Wait)"

  docker restart emby 1>/dev/null 2>&1
  docker restart nzbget 1>/dev/null 2>&1
  docker restart radarr 1>/dev/null 2>&1
  docker restart sonarr 1>/dev/null 2>&1
  docker restart plexpass 1>/dev/null 2>&1
  docker restart plexpublic 1>/dev/null 2>&1
  docker restart sabnzbd 1>/dev/null 2>&1

  file="/var/plexguide/donation.yes"
  if [ -e "$file" ]
    then
        echo "" 1>/dev/null 2>&1
    else
        echo "8. Donation Information - (Please Wait)"
        echo ""
        bash /opt/plexguide/scripts/menus/donate-menu.sh
    fi


############################################# Install a Post-Docker Fix ###################### END

else
    echo "Install Aborted - You Failed to Agree to Install the Program!"
    echo
    echo "You will be able to browse the programs but doing anything will cause"
    echo "problems! Good Luck!"
    echo
    bash /opt/plexguide/scripts/docker-no/continue.sh
fi

clear

cat << EOF