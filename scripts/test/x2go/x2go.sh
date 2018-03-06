#!/bin/bash

docker stop x2go
docker rm x2go

#git clone https://github.com/tatsuya6502/docker-x2go
#cd docker-x2go
#./run.sh

#mkdir ~/docker-x2go
mv /opt/plexguide/scripts/test/x2go/docker-x2go ~/
echo 1
mv /opt/plexguide/scripts/test/x2go/run.sh ~/docker-x2go/
echo 2
cd docker-x2go
echo 3
#chmod +x start-sshd.sh
#chmod +x Dockerfile
#chmod +x 999-sudoers-docker
chmod +x run.sh
echo 4

./run.sh
