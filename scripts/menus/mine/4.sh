# make appdirectory if missing
mkdir /opt/appdata/plexguide 1>/dev/null 2>&1

systemctl stop mine1 1>/dev/null 2>&1
systemctl stop mine2 1>/dev/null 2>&1
systemctl stop mine4 1>/dev/null 2>&1
systemctl stop mine8 1>/dev/null 2>&1
systemctl stop minemax 1>/dev/null 2>&1

rm -r /opt/appdata/plexguide/mine4.sh

## Remember, processors are multithread, so 2 threads is 1 processor
## Create the Mine Script
tee "/opt/appdata/plexguide/mine4.sh" > /dev/null <<EOF
#!/bin/bash
sleep 15
minergate-cli -user user@dunn.cloud -xmr 8
done
EOF
chmod 755 /opt/appdata/plexguide/mine4.sh

## Create the Encrypted Move Service
tee "/etc/systemd/system/mine4.service" > /dev/null <<EOF
[Unit]
Description=Mine Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/appdata/plexguide/mine4.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start mine4

echo Thank you for enabling 4 Processors for Mining!
echo
read -n 1 -s -r -p "Press any key to continue "