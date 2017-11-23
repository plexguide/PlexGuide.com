systemctl stop mine1
systemctl stop mine2
systemctl stop mine4
systemctl stop mine8
systemctl stop minemax

rm -r /opt/appdata/plexguide/mine.sh

## Remember, processors are multithread, so 2 threads is 1 processor
## Create the Mine Script
tee "/opt/appdata/plexguide/mine.sh" > /dev/null <<EOF
#!/bin/bash
sleep 15
minergate-cli -user user@dunn.cloud -xmr 2
done
EOF
chmod 755 /opt/appdata/plexguide/mine1.sh

## Create the Encrypted Move Service
tee "/etc/systemd/system/mine1.service" > /dev/null <<EOF
[Unit]
Description=Mine Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/appdata/plexguide/mine1.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start mine1

echo
echo Thank you for enabling 1 Processor for Mining!
echo
read -n 1 -s -r -p "Press any key to continue "