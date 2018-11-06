#!/usr/bin/env python3
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
touch /var/plexguide/pg.python.stored
start=$( cat /var/plexguide/pg.python )
stored=$( cat /var/plexguide/pg.python.stored )

if [ "$start" != "$stored" ]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  INSTALLING: Upgrading Python
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Python is a coding language that enables the use of powerful
modules that is utlized by PlexGuide

PLEASE STANDBY!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
sleep 5

## Disable IPv6
grep -q -F 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
grep -q -F 'net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
grep -q -F 'net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
sysctl -p

add-apt-repository main
add-apt-repository universe
add-apt-repository restricted
add-apt-repository multiverse
apt-get update

## Install Dependencies
apt-get install -y --reinstall
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
lxml

## Copy pip to /usr/bin
cp /usr/local/bin/pip /usr/bin/pip
cp /usr/local/bin/pip3 /usr/bin/pip3

# Prevents From Repeating
cat /var/plexguide/pg.python > /var/plexguide/pg.python.stored

fi
