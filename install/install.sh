#!/bin/bash
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  WARNING! READ for Ubuntu 18 Server Edition - 18.10!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PG will not work on Live Server or 18.10! We are not going to stop you,
but it will fail miserably! QUIT ASKING ON THE FORUMS!!!!

You must use 18.04 LTS! UB16 has no issue!

WAIT FOR 10 SECONDS!

EOF
sleep 10

# Disable IPv6
if [ -f /etc/sysctl.d/99-sysctl.conf ]; then
    grep -q -F 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
    grep -q -F 'net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
    grep -q -F 'net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
    sysctl -p
fi

# Upgrade
apt-get update

# Add APT repos
add-apt-repository main
add-apt-repository universe
add-apt-repository restricted
add-apt-repository multiverse

# Upgrade
apt-get update
apt-get upgrade
apt-get full-upgrade

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLING: PlexGuide Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By Installing PlexGuide, you are agree to the terms and conditions of
the Project GNUv3 License! Please Standby...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
sleep 5
apt-get install dialog -y
git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide && cp /opt/plexguide/menu/interface/alias/templates/plexguide /bin/
cp /opt/plexguide/menu/interface/alias/templates/plexguide /bin/plexguide

# Install Dependencies
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
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==18.1
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr
python -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==18.1
python -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
python -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr \
    ansible==${1-2.5.11}

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

chmod 755 /bin/plexguide
chown 1000:1000 /bin/plexguide

## Other Folders
mkdir -p /opt/appdata/plexguide
mkdir -p /var/plexguide

## Variables Need to Line Up with pg.sh (start)
echo "12" > /var/plexguide/pg.python
echo "11" > /var/plexguide/pg.ansible

clear

echo "Execute PlexGuide Anytime By Typing: plexguide"
echo
