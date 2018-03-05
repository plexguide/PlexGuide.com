#!/bin/bash

docker stop x2go
docker rm x2go

git clone https://github.com/tatsuya6502/docker-x2go
cd docker-x2go
./run.sh
