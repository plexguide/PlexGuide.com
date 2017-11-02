#!/bin/bash

curl -sSL https://get.docker.com | sh
sudo apt install docker-compose
sudo docker-compose -f docker-compose.yml up -d
