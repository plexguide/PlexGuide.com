#sudo apt-get install -y git python-pip python3-pip python-setuptools python3-setuptools && sudo easy_install -U pip && sudo easy_install3 -U pip && requests && sudo python3 -m pip install requests

apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python-dev \
    python-pip \
    python-netaddr
python -m pip install --upgrade \
    pyOpenSSL \
    pip \
    setuptools \
    requests \
    netaddr
python3 -m pip install --upgrade \
    pyOpenSSL \
    pip \
    setuptools \
    requests \
    netaddr