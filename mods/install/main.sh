#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###

# Update the package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget

# Specify the version of Python to install (optional)
PYTHON_VERSION=3.10.0

# Download and extract the Python source code
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
tar -xf Python-${PYTHON_VERSION}.tar.xz
cd Python-${PYTHON_VERSION}

# Configure and install Python
./configure --enable-optimizations
make -j $(nproc)
sudo make altinstall

# Install pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.10 get-pip.py

# Install necessary modules
sudo pip3.10 install numpy scipy pandas matplotlib

# Create symbolic links for the selected version (Python 3.10 in this example)
sudo ln -sf /usr/local/bin/python3.10 /usr/bin/python
sudo ln -sf /usr/local/bin/pip3.10 /usr/bin/pip

# Confirm the selected version
python --version
pip --version
