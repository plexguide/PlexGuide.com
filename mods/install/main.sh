#!/bin/bash

# Update the package list and install necessary dependencies
echo "Updating package list and installing necessary dependencies, please wait..."
sudo apt-get update > /dev/null
sudo apt-get install -y software-properties-common pv > /dev/null

# Stop any existing Flask app and remove app.py file
kill $(ps aux | grep 'gunicorn app:app' | awk '{print $2}') 2> /dev/null
rm -f app.py

# Remove app.py if it exists
if [ -f "app.py" ]; then
    rm app.py
fi

# Reset port 5000
#sudo fuser -k 5000/tcp

# Force remove /pg/var/yes
sudo rm -f /pg/var/yes

# Ensure /pg/var/ exists
sudo mkdir -p /pg/var/

# Install Flask and gunicorn
pip3 install Flask gunicorn

# Get IP address
ip_address=$(hostname -I | awk '{print $1}')

# Create Flask app
cat <<EOF > app.py
from flask import Flask, render_template_string, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template_string('<h1>Welcome to PlexGuide!</h1><form method="POST" action="/submit"><input type="submit" value="Install PG!"></form>')

@app.route('/submit', methods=['POST'])
def submit():
    with open('/pg/var/yes', 'w') as f:
        f.write('Yes')
    return 'Button clicked!'

if __name__ == '__main__':
    app.run(host='${ip_address}', port=5000)
EOF

# Run Flask app in the background with gunicorn
gunicorn app:app -b localhost:5000 -D

echo "Visit ${ip_address}:5000. Press the [Install] Button!"
echo ""

# Wait for button click
counter=1
while [ ! -f /pg/var/yes ]
do
    clear
    echo "$(date '+%Y-%m-%d %H:%M:%S') Waiting for button click (${ip_address}:5000) - Notice ${counter}"
    sleep 5
    counter=$((counter+1))
done

# Notify user that the button was clicked
echo "Thank you for agreeing to install PlexGuide X1!"

# Create necessary folders
echo "Creating necessary folders, please wait..."
for folder in "/pg/tmp" "/pg/var" "/pg/data"; do
  if [ -d "${folder}" ]; then
    echo "${folder} already exists, skipping creation."
  else
    echo "Creating ${folder}..."
    mkdir -p "${folder}"
  fi
done

# Delete all contents in /pg/tmp if it exists
if [ -d "/pg/tmp" ]; then
  echo "Deleting all contents in /pg/tmp, please wait..."
  rm -rf /pg/tmp/*
fi

# Check if Docker is already installed
if [ "$(command -v docker)" ]; then
  # Docker is already installed
  echo "Docker is already installed on this system."
  # Check if a specific version of Docker is installed
  if [ "$1" ]; then
    if docker --version | grep -qF "$1"; then
      # The specified version of Docker is already installed
      echo "Docker version $1 is already installed on this system."
      exit 0
    fi
  fi
  exit 0
fi

# Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Check if a specific version of Docker needs to be installed
if [ "$1" ]; then
  # Install a specific version of Docker
  echo "Installing Docker version $1..."
  sudo apt-get install -y docker-ce="$1"
fi

# Test Docker installation
echo "Testing Docker installation..."
sudo docker run hello-world

sleep 2

# Check if hello-world container ran successfully
if [[ "$(docker ps -lq)" == *"hello-world"* ]]; then
    echo "Script ran successfully!"
else
    echo "Error: Script encountered an issue."
fi
