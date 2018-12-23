#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
starter () {
  abc="/var/plexguide"
}

core () {
    touch /var/plexguide/pg.$1.stored
    start=$(cat /var/plexguide/pg.$1)
    stored=$(cat /varplexguide/pg.$1.stored)

if [ "$start" != "$stored" ]; then
  $1
  rolestored; fi
}

rolestored () {
  cat /var/plexguide/pg.$1 > /var/plexguide/pg.$1.stored
}

alias () {
  ansible-playbook /opt/plexguide/menu/$1/${1}.yml
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

rclone () {
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
