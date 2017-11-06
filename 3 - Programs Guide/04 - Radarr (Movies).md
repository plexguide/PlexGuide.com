![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)


# Install Radarr

![N](https://image.ibb.co/etHuY6/Snip20171029_13.png)

```sh
sudo apt update && sudo install libmono-cil-dev curl mediainfo
cd /opt
sudo wget $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
sudo tar -xvzf Radarr.develop.*.linux.tar.gz
```

# Creating a service for Radarr
```sh
sudo nano /etc/systemd/system/radarr.service
```

- Copy & Paste the info below into the ervice

```sh
[Unit]
Description=Radarr Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/mono /opt/Radarr/Radarr.exe --nobrowser &
TimeoutStopSec=20
KillMode=process 
Restart=always

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X to exit and save

## Start the Radarr Service
```sh
sudo systemctl daemon-reload
sudo systemctl enable radarr.service
sudo systemctl start radarr.service
sudo systemctl status radarr.service
```

- Press CTRL+C to exit status message
- To test, goto your http://ipv4address:7878

## Radarr Configuration
To configure radarr, please go to the Radarr config wiki at: https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Radarr-Guide
