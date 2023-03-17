#!/bin/bash
############# https://github.com/plexguide/PlexGuide.com/graphs/contributors ###

#!/bin/bash

# Update the package list and install necessary dependencies
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Install Python (Python 3.10 in this example)
PYTHON_VERSION=3.10.0
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
tar -xf Python-${PYTHON_VERSION}.tar.xz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
make -j $(nproc)
sudo make altinstall
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.10 get-pip.py

# Specify the version of Ansible to install (optional)
ANSIBLE_VERSION=4.11.0

# Install Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible-${ANSIBLE_VERSION}
sudo apt-get update
sudo apt-get install -y ansible

# Specify the version of Docker to install (optional)
DOCKER_VERSION=20.10.12~3-0~ubuntu-focal

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io

# Add current user to the docker group
sudo usermod -aG docker $USER

# Confirm the installed versions
python --version
ansible --version
docker --version

# Create directories if they do not exist
for dir in ['/pg/var', '/pg/test1', '/pg/test2']:
    if not os.path.exists(dir):
        print(f"Creating directory {dir}")
        os.makedirs(dir)
    else:
        print(f"Directory {dir} already exists, skipping")

# Confirm the directories have been created
for dir in ['/pg/var', '/pg/test1', '/pg/test2']:
    print(f"{dir} permissions: {os.stat(dir).st_mode & 0o777:o}")
EOF
)

# Execute the Python script
python3 -c "$python_script"
