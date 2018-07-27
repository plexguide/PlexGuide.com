#!/bin/sh
intended_id=6000
if [ $(id -u) -ne $intended_id ]; then
    echo "Improper UID, attempting to run as $intended_id"
    sudo -u "#$intended_id" $0
    # exit with the same return value that `sudo $0` did
    exit $?
fi
rest_of_script