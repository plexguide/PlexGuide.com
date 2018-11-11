## Disable IPv6
grep -q -F 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
grep -q -F 'net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
grep -q -F 'net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
sysctl -p

## Install Dependencies
apt-get install -y --reinstall \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python-dev \
    python-pip
pip3 install --upgrade --force-reinstall --disable-pip-version-check pip==9.0.3
pip3 install --upgrade --force-reinstall setuptools
pip3 install --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr \
    google-api-python-client \
    google_auth_oauthlib \
    arrow
pip install --upgrade --force-reinstall --disable-pip-version-check pip==9.0.3
pip install --upgrade --force-reinstall setuptools
pip install --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr \
    #ansible==${1-2.5.4}
## Copy pip to /usr/bin
cp /usr/local/bin/pip /usr/bin/pip
cp /usr/local/bin/pip3 /usr/bin/pip3
