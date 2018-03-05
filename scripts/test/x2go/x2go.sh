#!/bin/bash

docker stop x2go
docker rm x2go

#git clone https://github.com/tatsuya6502/docker-x2go
#cd docker-x2go
#./run.sh

#mkdir ~/docker-x2go
cp /opt/plexguide/scripts/test/x2go/docker-x2go ~/
cp /opt/plexguide/scripts/test/x2go/run.sh ~/
cd docker-x2go
#chmod +x start-sshd.sh
#chmod +x Dockerfile
#chmod +x 999-sudoers-docker
chmod +x run.sh

./run.sh
