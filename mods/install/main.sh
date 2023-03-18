#!/bin/bash

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

# Update the package list and install necessary dependencies
echo "Updating package list and installing necessary dependencies, please wait..."
sudo apt-get update > /dev/null
sudo apt-get install -y software-properties-common pv > /dev/null

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