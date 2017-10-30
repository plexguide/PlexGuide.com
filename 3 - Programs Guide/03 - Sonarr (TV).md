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

## Sonnar Configurations

- Sonnar - http://ipv4address:8989
- Settings: Click in the upper right
  - Advanced Settings: Turn on, far right, flip on and [Click] save
 - Media Management Tab
 - Rename Episodes: Flip to yes
 - Analyse Video Files: Flip to no (if you forget, you will hit the 24hr Google Ban all the time)
 - [Click] save changes at the top right
- Profiles Tab
  - Keep the (Any) profile, delete the rest. To delete, click the profiles and [Click] the delete button
  - [Click] Any (the settings below are recommended)
  - Cutoff WEBDL-720p
  - Qualities - Follow the order and have the ones listed below on; not listed... keep off (recommendation)
     - Bluray-1080p
     - Bluray-720p
     - WEBDL-1080p
     - HDTV-1080p
     - HDTV-720p
     - DVD
     - WEBDL-480p
     - SDTV
     - Unknown
  - [Click] save changes at top right
- Indexers Tab: You will need at least one provider. See root area for a file called "Indexers".
  - Download Client Tab:
    - SABNZBD:  Turn this one on
    - Name: SABNZBD
    - Host: Domain or IPV4 Address
    - Port: 8090
    - API Key: Goto SABNZBD - http://YOURIP-Domain:8090/sabnzbd/config/general/ and get the API KEY
    - Username: If you made a username in SAB, then put it here; otherwise leave blank
    - Password: If you made a password in SAB, then put it here; otherwise leave blank
    - Category: TV
    - Recent Priority: Hight
    - Older Priority: Normal or Low (if you love TV downloads more than movies; make normal)
    - [Click] Test - if having problems, check your IP, port, username and etc.  Trust me, it's you.
    - [Click] Save - if all is well
- General Tab:
  - Security:
    - Authentication: 
    - Forms (Login PaGe)
      - Username: remember it
      - Password: remember it
  - Automatic: On
  - [Click] save changes at top right
  - Series Icon: [Click] at the top
  - Either click Import (if you have shows) or Add Series (if you don't or want more)
  - If your rclone is working, then when you add a path... it
  - Should be: /mnt/rclone-union/zilch/tv/ (May Take a Minute)
  - [Click] Ok at the very bottom
  - In the future if you have shows already and you click import, click the TV Folder under RECENT
