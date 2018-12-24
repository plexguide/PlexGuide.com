#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh

updateprime() {
  abc="/var/plexguide"
  mkdir -p ${abc}
  echo "50" > ${abc}/pg.pythonstart
  echo "10" > ${abc}/pg.aptupdate
  echo "149" > ${abc}/pg.preinstall
  echo "9" > ${abc}/pg.folders
  echo "13" > ${abc}/pg.rcloneprime
  echo "10" > ${abc}/pg.dockerinstall
  echo "12" > ${abc}/server.id
  echo "24" > ${abc}/pg.dependency
  echo "10" > ${abc}/pg.docstart
  echo "2" > ${abc}/pg.watchtower
  echo "1" > ${abc}/pg.motd
  echo "87" > ${abc}/pg.alias
  echo "2" > ${abc}/pg.dep
  echo "2" > ${abc}/pg.cleaner
  echo "3" > ${abc}/pg.gcloud
  echo "12" > ${abc}/pg.hetzner
  echo "1" > ${abc}/pg.amazonaws
  echo "7.3" > ${abc}/pg.verionid
}

pginstall () {
  updateprime
  core pythonstart
  core aptupdate
  core alias
  core folders
  core dependency
  core docstart
  core dockerinstall
  core motd
  core hetzner
  core gcloud
  core rcloneprime
  core cleaner
  core watchtower

}

core () {
    touch /var/plexguide/pg.${1}.stored
    start=$(cat /var/plexguide/pg.${1})
    stored=$(cat /var/plexguide/pg.${1}.stored)
    if [ "$start" != "$stored" ]; then
      $1
      cat /var/plexguide/pg.${1} > /var/plexguide/pg.${1}.stored;
    fi
}

############################################################ INSTALLER FUNCTIONS
alias () {
  ansible-playbook /opt/plexguide/menu/alias/alias.yml
}

aptupdate () {
  yes | apt-get update
  yes | apt-get install software-properties-common
  yes | apt-get install sysstat nmon
  sed -i 's/false/true/g' /etc/default/sysstat
}

cleaner () {
  ansible-playbook /opt/plexguide/menu/pg.yml --tags autodelete &>/dev/null &
  ansible-playbook /opt/plexguide/menu/pg.yml --tags clean &>/dev/null &
  ansible-playbook /opt/plexguide/menu/pg.yml --tags clean-encrypt &>/dev/null &
}

dependency () {
  ospgversion=$(cat /var/plexguide/os.version)
  if [ "$ospgversion" == "debian" ]; then
    ansible-playbook /opt/plexguide/menu/dependency/dependencydeb.yml;
  else
    ansible-playbook /opt/plexguide/menu/dependency/dependency.yml; fi
}

docstart () {
   ansible-playbook /opt/plexguide/menu/pg.yml --tags docstart
}

folders () {
  ansible-playbook /opt/plexguide/menu/folders/main.yml
}

hetzner () {
  if [ -e "$file" ]; then rm -rf /bin/hcloud; fi
  version="v1.10.0"
  wget -P /opt/appdata/plexguide "https://github.com/hetznercloud/cli/releases/download/$version/hcloud-linux-amd64-$version.tar.gz"
  tar -xvf "/opt/appdata/plexguide/hcloud-linux-amd64-$version.tar.gz" -C /opt/appdata/plexguide
  mv "/opt/appdata/plexguide/hcloud-linux-amd64-$version/bin/hcloud" /bin/
  rm -rf /opt/appdata/plexguide/hcloud-linux-amd64-$version.tar.gz
  rm -rf /opt/appdata/plexguide/hcloud-linux-amd64-$version
}

gcloud () {
  export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
  sudo apt-get update && sudo apt-get install google-cloud-sdk -y
}

motd () {
  ansible-playbook /opt/plexguide/menu/motd/motd.yml
}

pythonstart () {
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
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==9.0.3
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
  python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
      pyOpenSSL \
      requests \
      netaddr
  python -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==9.0.3
  python -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
  python -m pip install --disable-pip-version-check --upgrade --force-reinstall ansible==${1-2.5.11}

  ## Copy pip to /usr/bin
  cp /usr/local/bin/pip /usr/bin/pip
  cp /usr/local/bin/pip3 /usr/bin/pip3

  mkdir -p /etc/ansible/inventories/ 1>/dev/null 2>&1
  echo "[local]" > /etc/ansible/inventories/local
  echo "127.0.0.1 ansible_connection=local" >> /etc/ansible/inventories/local

  ### Reference: https://docs.ansible.com/ansible/2.4/intro_configuration.html
  echo "[defaults]" > /etc/ansible/ansible.cfg
  echo "command_warnings = False" >> /etc/ansible/ansible.cfg
  echo "callback_whitelist = profile_tasks" >> /etc/ansible/ansible.cfg
  echo "inventory = /etc/ansible/inventories/local" >> /etc/ansible/ansible.cfg

  # Variables Need to Line Up with pg.sh (start)
  touch /var/plexguide/background.1
}

rcloneprime () {
  ansible-playbook /opt/plexguide/menu/pg.yml --tags rcloneinstall

tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF
}

dockerinstall () {
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
    if [ -e "$file" ]
      then
      echo "INFO - SUCCESS: Docker Installed!"
      sleep 5
    else
      echo "INFO - FAILED: Docker Failed to Install! Exiting PlexGuide!"
        exit
      fi
  fi
}

watchtower () {

  file="/var/plexguide/watchtower.wcheck"
  if [ -e "$file" ]; then
  echo "4" > /var/plexguide/watchtower.wcheck
  fi

  wcheck=$(cat "/var/plexguide/watchtower.wcheck")
    if [[ "$wcheck" -ge "1" && "$wcheck" -le "3" ]]; then
    wexit="1"
    else wexit=0; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  PG WatchTower Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  NOTE: WatchTower updates your containers soon as possible!

1 - Containers: Auto-Update All
2 - Containers: Auto-Update All Except | Plex & Emby
3 - Containers: Never Update
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Standby
  read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    watchtowergen
    ansible-playbook /opt/plexguide/containers/watchtower.yml
    echo "1" > /var/plexguide/watchtower.wcheck
  elif [ "$typed" == "2" ]; then
    watchtowergen
    sed -i -e "/plex/d" /tmp/watchtower.set 1>/dev/null 2>&1
    sed -i -e "/emby/d" /tmp/watchtower.set 1>/dev/null 2>&1
    ansible-playbook /opt/plexguide/containers/watchtower.yml
    echo "2" > /var/plexguide/watchtower.wcheck
  elif [ "$typed" == "3" ]; then
    echo null > /tmp/watchtower.set
    ansible-playbook /opt/plexguide/containers/watchtower.yml
    echo "3" > /var/plexguide/watchtower.wcheck
  elif [[ "$typed" == "Z" || "$typed" != "z" ]]; then
    if [ "$wexit" == "0" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Unable to Exit! You Must set a WatchTower Preference Once!
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

watchtowergen () {
  bash /opt/plexguide/containers/_appsgen.sh
  while read p; do
    echo -n $p >> /tmp/watchtower.set
    echo -n " " >> /tmp/watchtower.set
  done </var/plexguide/app.list
}
