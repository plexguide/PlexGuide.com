    mv plexdrive4.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable mongod
    systemctl start mongod   