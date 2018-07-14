#!/bin/sh

docker stop x2go
docker rm x2go
echo
echo Creating container
echo
docker run -it -d -p 2222:22 --name=x2go -v=/mnt:/mnt -v=/opt:/opt quay.io/tatsuya6502/x2go:latest
echo
echo Please wait for ssh key
echo
sleep 3
echo Copy key and save to your pc using Notepad and point X2Go Client to it!
echo
docker logs x2go
