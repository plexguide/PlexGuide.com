#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh

updateprime() {
  abc="/var/plexguide"
  mkdir -p ${abc}
  chmod 0775 ${abc}
  chown 1000:1000 ${abc}

  mkdir -p /opt/appdata/plexguide
  chmod 0775 /opt/appdata/plexguide
  chown 1000:1000 /opt/appdata/plexguide

  variable /var/plexguide/pgfork.project "UPDATE ME"
  variable /var/plexguide/pgfork.version "changeme"
  variable /var/plexguide/tld.program "portainer"
  variable /opt/appdata/plexguide/plextoken ""
  variable /var/plexguide/server.ht ""
  variable /var/plexguide/server.email "NOT-SET"
  variable /var/plexguide/server.domain "NOT-SET"
  variable /var/plexguide/pg.number "New-Install"
  variable /var/plexguide/emergency.log ""
  variable /var/plexguide/pgbox.running ""
  pgnumber=$(cat /var/plexguide/pg.number)

  hostname -I | awk '{print $1}' >/var/plexguide/server.ip
  file="${abc}/server.hd.path"
  if [ ! -e "$file" ]; then echo "/mnt" >${abc}/server.hd.path; fi

  file="${abc}/new.install"
  if [ ! -e "$file" ]; then newinstall; fi

  ospgversion=$(cat /etc/*-release | grep Debian | grep 9)
  if [ "$ospgversion" != "" ]; then
    echo "debian" >${abc}/os.version
  else echo "ubuntu" >${abc}/os.version; fi

  echo "3" >${abc}/pg.mergerinstall
  echo "52" >${abc}/pg.pythonstart
  echo "12" >${abc}/pg.aptupdate
  echo "150" >${abc}/pg.preinstall
  echo "24" >${abc}/pg.folders
  echo "16" >${abc}/pg.dockerinstall
  echo "15" >${abc}/pg.server
  echo "1" >${abc}/pg.serverid
  echo "33" >${abc}/pg.dependency
  echo "11" >${abc}/pg.docstart
  echo "2" >${abc}/pg.motd
  echo "115" >${abc}/pg.alias
  echo "3" >${abc}/pg.dep
  echo "3" >${abc}/pg.cleaner
  echo "3" >${abc}/pg.gcloud
  echo "12" >${abc}/pg.hetzner
  echo "1" >${abc}/pg.amazonaws
  echo "8.4" >${abc}/pg.verionid
  echo "11" >${abc}/pg.watchtower
  echo "1" >${abc}/pg.installer
  echo "7" >${abc}/pg.prune
  echo "21" >${abc}/pg.mountcheck

}

pginstall() {
  updateprime
  bash /opt/plexguide/menu/pggce/gcechecker.sh
  core pythonstart
  core aptupdate
  core alias &>/dev/null &
  core folders
  core dependency
  core mergerinstall
  core dockerinstall
  core docstart

  touch /var/plexguide/install.roles
  rolenumber=3
  # Roles Ensure that PG Replicates and has once if missing; important for startup, cron and etc
  if [[ $(cat /var/plexguide/install.roles) != "$rolenumber" ]]; then
    rm -rf /opt/communityapps
    rm -rf /opt/coreapps
    rm -rf /opt/pgshield

    pgcore
    pgcommunity
    pgshield
    echo "$rolenumber" >/var/plexguide/install.roles
  fi

  portainer
  pgui
  core motd &>/dev/null &
  core hetzner &>/dev/null &
  core gcloud
  core cleaner &>/dev/null &
  core serverid
  core watchtower
  core prune
  customcontainers &>/dev/null &
  pgedition
  core mountcheck
  emergency
  pgdeploy
}

core() {
  touch /var/plexguide/pg."${1}".stored
  start=$(cat /var/plexguide/pg."${1}")
  stored=$(cat /var/plexguide/pg."${1}".stored)
  if [ "$start" != "$stored" ]; then
    $1
    cat /var/plexguide/pg."${1}" >/var/plexguide/pg."${1}".stored
  fi
}

############################################################ INSTALLER FUNCTIONS
alias() {
  ansible-playbook /opt/plexguide/menu/alias/alias.yml
}

aptupdate() {
  yes | apt-get update
  yes | apt-get install software-properties-common
  yes | apt-get install sysstat nmon
  sed -i 's/false/true/g' /etc/default/sysstat
}

customcontainers() {
  mkdir -p /opt/mycontainers
  touch /opt/appdata/plexguide/rclone.conf
  mkdir -p /opt/communityapps/apps
  rclone --config /opt/appdata/plexguide/rclone.conf copy /opt/mycontainers/ /opt/communityapps/apps
}

cleaner() {
  ansible-playbook /opt/plexguide/menu/pg.yml --tags autodelete &>/dev/null &
  ansible-playbook /opt/plexguide/menu/pg.yml --tags clean &>/dev/null &
  ansible-playbook /opt/plexguide/menu/pg.yml --tags clean-encrypt &>/dev/null &
}

dependency() {
  ospgversion=$(cat /var/plexguide/os.version)
  if [ "$ospgversion" == "debian" ]; then
    ansible-playbook /opt/plexguide/menu/dependency/dependencydeb.yml
  else
    ansible-playbook /opt/plexguide/menu/dependency/dependency.yml
  fi
}

docstart() {
  ansible-playbook /opt/plexguide/menu/pg.yml --tags docstart
}

emergency() {
  variable /var/plexguide/emergency.display "On"
  if [[ $(ls /opt/appdata/plexguide/emergency) != "" ]]; then

    # If not on, do not display emergency logs
    if [[ $(cat /var/plexguide/emergency.display) == "On" ]]; then

      tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  Emergency & Warning Log Generator | Visit - http://emlog.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: This can be turned [On] or Off in Settings!

EOF

      countmessage=0
      while read p; do
        let countmessage++
        echo -n "${countmessage}. " && cat /opt/appdata/plexguide/emergency/$p
      done <<<"$(ls /opt/appdata/plexguide/emergency)"

      echo
      read -n 1 -s -r -p "Acknowledge Info | Press [ENTER]"
      echo
    else
      touch /var/plexguide/emergency.log
    fi
  fi

}

folders() {
  ansible-playbook /opt/plexguide/menu/installer/folders.yml
}

prune() {
  ansible-playbook /opt/plexguide/menu/prune/main.yml
}

hetzner() {
  if [ -e "$file" ]; then rm -rf /bin/hcloud; fi
  version="v1.10.0"
  wget -P /opt/appdata/plexguide "https://github.com/hetznercloud/cli/releases/download/$version/hcloud-linux-amd64-$version.tar.gz"
  tar -xvf "/opt/appdata/plexguide/hcloud-linux-amd64-$version.tar.gz" -C /opt/appdata/plexguide
  mv "/opt/appdata/plexguide/hcloud-linux-amd64-$version/bin/hcloud" /bin/
  rm -rf /opt/appdata/plexguide/hcloud-linux-amd64-$version.tar.gz
  rm -rf /opt/appdata/plexguide/hcloud-linux-amd64-$version
}

gcloud() {
  export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
  sudo apt-get update && sudo apt-get install google-cloud-sdk -y
}

mergerinstall() {

  ub16check=$(cat /etc/*-release | grep xenial)
  ub18check=$(cat /etc/*-release | grep bionic)
  deb9check=$(cat /etc/*-release | grep stretch)
  activated=false

  apt --fix-broken install -y
  apt-get remove mergerfs -y
  mkdir -p /var/plexguide

  if [ "$ub16check" != "" ]; then
    activated=true
    echo "ub16" >/var/plexguide/mergerfs.version
    wget "https://github.com/trapexit/mergerfs/releases/download/2.28.1/mergerfs_2.28.1.ubuntu-xenial_amd64.deb"

  elif [ "$ub18check" != "" ]; then
    activated=true
    echo "ub18" >/var/plexguide/mergerfs.version
    wget "https://github.com/trapexit/mergerfs/releases/download/2.28.1/mergerfs_2.28.1.ubuntu-bionic_amd64.deb"

  elif [ "$deb9check" != "" ]; then
    activated=true
    echo "deb9" >/var/plexguide/mergerfs.version
    wget "https://github.com/trapexit/mergerfs/releases/download/2.28.1/mergerfs_2.28.1.debian-stretch_amd64.deb"

  elif [ "$activated" != "true" ]; then
    activated=true && echo "ub18 - but didn't detect correctly" >/var/plexguide/mergerfs.version
    wget "https://github.com/trapexit/mergerfs/releases/download/2.28.1/mergerfs_2.28.1.ubuntu-bionic_amd64.deb"
  else
    apt-get install g++ pkg-config git git-buildpackage pandoc debhelper libfuse-dev libattr1-dev -y
    git clone https://github.com/trapexit/mergerfs.git
    cd mergerfs
    make clean
    make deb
    cd ..
  fi

  apt install -y ./mergerfs*_amd64.deb
  rm mergerfs*_amd64.deb

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  MergerFS has been updated! Requires PG Clone redeployment.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INFORMATION:  MergerFS was updated on your system and brings performance improvements!
Users have reported faster plex scanning and playback with the new mergerfs and pgclone configuration.

ATTENTION:
You are required to re-deploy your mounts in the PG Clone menu (option 4, option A).
It is advised to check the VFS mount settings in the options menu (C,2), as options have been updated.

WARNING: This is not optional, you must redeploy your mounts in the PG Clone menu.
Your mounts are currently down until you re-deploy pg clone as it requires configuration updates!
This is not done for you, you must go to the PG Clone Menu (option 4) and deploy (option A).

We apologize for this one-time inconvenience.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty

}

motd() {
  ansible-playbook /opt/plexguide/menu/motd/motd.yml
}

mountcheck() {
  bash /opt/plexguide/menu/pgcloner/solo/pgui.sh
  ansible-playbook /opt/pgui/pgui.yml
  ansible-playbook /opt/plexguide/menu/pgui/mcdeploy.yml
}

localspace() {
  ansible-playbook /opt/pgui/pgui.yml
  ansible-playbook /opt/plexguide/menu/pgui/localspace.yml

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  PG User Interface (PGUI) Installed / Updated
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INFORMATION:  PGUI is a simple interface that provides information,
warnings, and stats that will assist both yourself and tech support!
To turn this off, goto settings and turn off/on the PG User Interface!

VISIT:
https://pgui.yourdomain.com | http://pgui.domain.com:8555 | ipv4:8555

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Acknowledge Info | Press [ENTER] ' typed </dev/tty

}

newinstall() {
  rm -rf /var/plexguide/pg.exit 1>/dev/null 2>&1
  file="${abc}/new.install"
  if [ ! -e "$file" ]; then
    touch ${abc}/pg.number && echo off >/tmp/program_source
    bash /opt/plexguide/menu/version/file.sh
    file="${abc}/new.install"
    if [ ! -e "$file" ]; then exit; fi
  fi
}

pgdeploy() {
  touch /var/plexguide/pg.edition
  bash /opt/plexguide/menu/start/start.sh
}

pgedition() {
  file="${abc}/path.check"
  if [ ! -e "$file" ]; then touch ${abc}/path.check && bash /opt/plexguide/menu/dlpath/dlpath.sh; fi
  # FOR PG-BLITZ
  file="${abc}/project.deployed"
  if [ ! -e "$file" ]; then echo "no" >${abc}/project.deployed; fi
  file="${abc}/project.keycount"
  if [ ! -e "$file" ]; then echo "0" >${abc}/project.keycount; fi
  file="${abc}/server.id"
  if [ ! -e "$file" ]; then echo "[NOT-SET]" -rf >${abc}/rm; fi
}

portainer() {
  dstatus=$(docker ps --format '{{.Names}}' | grep "portainer")
  if [ "$dstatus" != "portainer" ]; then
    ansible-playbook /opt/coreapps/apps/portainer.yml &>/dev/null &
  fi
}

# Roles Ensure that PG Replicates and has once if missing; important for startup, cron and etc
pgcore() { if [ ! -e "/opt/coreapps/place.holder" ]; then ansible-playbook /opt/plexguide/menu/pgbox/pgboxcore.yml; fi; }
pgcommunity() { if [ ! -e "/opt/communityapps/place.holder" ]; then ansible-playbook /opt/plexguide/menu/pgbox/pgboxcommunity.yml; fi; }
pgshield() { if [ ! -e "/opt/pgshield/place.holder" ]; then
  echo 'pgshield' >/var/plexguide/pgcloner.rolename
  echo 'PGShield' >/var/plexguide/pgcloner.roleproper
  echo 'PGShield' >/var/plexguide/pgcloner.projectname
  echo 'v8.6' >/var/plexguide/pgcloner.projectversion
  echo 'pgshield.sh' >/var/plexguide/pgcloner.startlink
  ansible-playbook "/opt/plexguide/menu/pgcloner/corev2/primary.yml"
fi; }

pgui() {
  file="/var/plexguide/pgui.switch"
  if [ ! -e "$file" ]; then echo "On" >/var/plexguide/pgui.switch; fi

  pguicheck=$(cat /var/plexguide/pgui.switch)
  if [[ "$pguicheck" == "On" ]]; then

    dstatus=$(docker ps --format '{{.Names}}' | grep "pgui")
    if [ "$dstatus" != "pgui" ]; then
      bash /opt/plexguide/menu/pgcloner/solo/pgui.sh
      ansible-playbook /opt/pgui/pgui.yml
    fi
  fi
}

pythonstart() {

  ansible="2.8.2"
  pip="19.1.1"

  apt-get install -y --reinstall \
    nano \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python-dev \
    python-pip
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==${pip}
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr
  python -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==${pip}
  python -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
  python -m pip install --disable-pip-version-check --upgrade --force-reinstall ansible==${1-$ansible}

  ## Copy pip to /usr/bin
  cp /usr/local/bin/pip /usr/bin/pip
  cp /usr/local/bin/pip3 /usr/bin/pip3

  mkdir -p /etc/ansible/inventories/ 1>/dev/null 2>&1
  echo "[local]" >/etc/ansible/inventories/local
  echo "127.0.0.1 ansible_connection=local" >>/etc/ansible/inventories/local

  ### Reference: https://docs.ansible.com/ansible/2.4/intro_configuration.html
  echo "[defaults]" >/etc/ansible/ansible.cfg
  echo "deprecation_warnings=False" >>/etc/ansible/ansible.cfg
  echo "command_warnings = False" >>/etc/ansible/ansible.cfg
  echo "callback_whitelist = profile_tasks" >>/etc/ansible/ansible.cfg
  echo "inventory = /etc/ansible/inventories/local" >>/etc/ansible/ansible.cfg

  # Variables Need to Line Up with pg.sh (start)
  touch /var/plexguide/background.1
}

dockerinstall() {
  ospgversion=$(cat /var/plexguide/os.version)
  if [ "$ospgversion" == "debian" ]; then
    ansible-playbook /opt/plexguide/menu/pg.yml --tags dockerdeb
  else
    ansible-playbook /opt/plexguide/menu/pg.yml --tags docker
    # If Docker FAILED, Emergency Install
    file="/usr/bin/docker"
    if [ ! -e "$file" ]; then
      clear
      echo "Installing Docker the Old School Way - (Please Be Patient)"
      sleep 2
      clear
      curl -fsSL get.docker.com -o get-docker.sh
      sh get-docker.sh
      echo ""
      echo "Starting Docker (Please Be Patient)"
      sleep 2
      systemctl start docker
      sleep 2
    fi

    ##### Checking Again, if fails again; warns user
    file="/usr/bin/docker"
    if [ -e "$file" ]; then
      sleep 5
    else
      echo "INFO - FAILED: Docker Failed to Install! Exiting PGBlitz!"
      exit
    fi
  fi
}

serverid() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️   Establishing Server ID               💬  Use One Word & Keep it Simple
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '🌏  TYPE Server ID | Press [ENTER]: ' typed </dev/tty

  if [ "$typed" == "" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - The Server ID Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 1
    serverid
  else
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: Server ID $typed Established
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    echo "$typed" >/var/plexguide/server.id
    sleep 1
  fi
}

watchtower() {

  file="/var/plexguide/watchtower.wcheck"
  if [ ! -e "$file" ]; then
    echo "4" >/var/plexguide/watchtower.wcheck
  fi

  wcheck=$(cat "/var/plexguide/watchtower.wcheck")
  if [[ "$wcheck" -ge "1" && "$wcheck" -le "3" ]]; then
    wexit="1"
  else wexit=0; fi
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG WatchTower Edition          📓 Reference: watchtower.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  WatchTower updates your containers soon as possible!

[1] Containers: Auto-Update All
[2] Containers: Auto-Update All Except | Plex & Emby
[3] Containers: Never Update
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Standby
  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty
  if [ "$typed" == "1" ]; then
    watchtowergen
    ansible-playbook /opt/coreapps/apps/watchtower.yml
    echo "1" >/var/plexguide/watchtower.wcheck
  elif [ "$typed" == "2" ]; then
    watchtowergen
    sed -i -e "/plex/d" /tmp/watchtower.set 1>/dev/null 2>&1
    sed -i -e "/emby/d" /tmp/watchtower.set 1>/dev/null 2>&1
    sed -i -e "/jellyfin/d" /tmp/watchtower.set 1>/dev/null 2>&1
    ansible-playbook /opt/coreapps/apps/watchtower.yml
    echo "2" >/var/plexguide/watchtower.wcheck
  elif [ "$typed" == "3" ]; then
    echo null >/tmp/watchtower.set
    ansible-playbook /opt/coreapps/apps/watchtower.yml
    echo "3" >/var/plexguide/watchtower.wcheck
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    if [ "$wexit" == "0" ]; then
      tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️   WatchTower Preference Must be Set Once!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3
      watchtower
    fi
    exit
  else
    badinput
    watchtower
  fi
}

watchtowergen() {
  bash /opt/coreapps/apps/_appsgen.sh
  bash /opt/communityapps/apps/_appsgen.sh
  while read p; do
    echo -n $p >>/tmp/watchtower.set
    echo -n " " >>/tmp/watchtower.set
  done </var/plexguide/app.list
}
