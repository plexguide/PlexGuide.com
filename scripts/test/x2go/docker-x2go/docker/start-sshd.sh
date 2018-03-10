#!/bin/sh

# Create ssh "client" key
# http://stackoverflow.com/a/20977657

USER_HOME=/home/docker

KEYGEN=/usr/bin/ssh-keygen
KEYFILE=${USER_HOME}/.ssh/id_rsa

if [ ! -f $KEYFILE ]; then
    $KEYGEN -q -t rsa -N "" -f $KEYFILE
    cat $KEYFILE.pub >> ${USER_HOME}/.ssh/authorized_keys
fi

echo "== Use this private key to log in =="
cat $KEYFILE

# Start sshd
/usr/sbin/sshd -D
