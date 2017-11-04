![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# Purpose

- Will create a service on this later; one script is executed
- Goto http://ipaddress.com/check.txt or http://domain-name/check.txt afterwards
- This requires the apache install from prior

```sh
cd /var/www/html
sudo nano check.sh
```

Post this into the script

```sh
#!/bin/bash

while true
do
#
sudo systemctl status move > check.txt
sleep 5
done
```

Press CTRL + X to save

## Script permissions
```sh
sudo chmod 755 /var/www/html/check.sh
```

## Create Check Service
```sh
sudo nano /etc/systemd/system/check.service
```

Post this into the script

```sh
[Unit]
Description=Move Check Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /var/www/html/check.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
```

Press CTRL+X and then Yes to save

## Start and Enable the Check Service

```sh
sudo systemctl daemon-reload
sudo systemctl enable check.service
sudo systemctl start check.service
sudo systemctl status check.service
```

Press CTRL + C to exit the status message

Now goto http://ipaddress-or-domain/check.txt - Refresh browser every 5 seconds and you'll see the countdown
