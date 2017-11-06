![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# Sonarr
- Program that manages and downloads TV shows

![N](https://image.ibb.co/nkfnmR/Snip20171029_14.png)

## Install Sonarr
```sh
### Copy each line one by one
sudo apt-get install libmono-cil-dev
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
sudo echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
sudo apt-get update
sudo apt-get install nzbdrone
```

### Creating a service for Sonnar
```sh
sudo nano /etc/systemd/system/sonarr.service
```

- Copy and Paste the Information Below

```sh
[Unit]
Description=Sonarr Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/mono /opt/NzbDrone/NzbDrone.exe -nobrowser &
TimeoutStopSec=20
KillMode=process 
Restart=always

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X to exit and save

### Start the Sonnar Service

```sh
sudo systemctl daemon-reload
sudo systemctl enable sonarr.service
sudo systemctl start sonarr.service
sudo systemctl status sonarr.service
```

- Press CTRL+C to exit status message
- To test, goto your http://ipv4address:8989

To configure sonarr, please visit our wiki: https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Sonarr-Guide
