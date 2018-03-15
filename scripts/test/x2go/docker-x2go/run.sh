#!/bin/sh

docker stop x2go
docker rm x2go
docker run -it -d -p 2222:22 --name=x2go -v=/mnt:/mnt -v=/opt:/opt quay.io/tatsuya6502/x2go:latest
sleep 3
docker logs x2go
