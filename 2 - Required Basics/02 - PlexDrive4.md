![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# PlexDrive4
Establishes a read-only file system to prevent API bans with plex.  PD4 is used over 5 due to better stability.

![N](https://github.com/dweidenfeld/plexdrive/raw/master/logo/banner.png)

## Author Info
https://github.com/dweidenfeld/plexdrive

## MangoDB
Database program utilized by PlexDrive4

### Install MangoDB
```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org
```

### Enable MangoDB Service

```sh
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod
sudo systemctl status mongod
```

- Press CTRL+C to escape

## Install PlexDrive4
```sh
cd /tmp
sudo wget https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64
sudo mv plexdrive-linux-amd64 plexdrive4
sudo mv plexdrive4 /usr/bin/
cd /usr/bin/
sudo chown root:root /usr/bin/plexdrive4
sudo chmod 755 /usr/bin/plexdrive4
sudo mkdir /mnt/plexdrive4 && sudo chmod 755 /mnt/plexdrive4
cd ~
```
### Execute PlexDrive
Let Plex4 Run! Do not do anything else unless completed!

```sh
sudo screen plexdrive4 --uid=0 --gid=0 -o allow_other -v 2 --refresh-interval=1m /mnt/plexdrive4
```

### Creating a service for PlexDrive4

```sh
sudo nano /etc/systemd/system/plexdrive4.service
```

- Copy & Paste into the File!

```sh
[Unit]
Description=PlexDrive4 Service
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/plexdrive4 --uid=0 --gid=0 --fuse-options=allow_other --refresh-interval=1m /mnt/plexdrive4
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X and then Yes to save

### Enable PlexDrive Service

```sh
sudo systemctl daemon-reload
sudo systemctl enable plexdrive4.service
sudo systemctl start plexdrive4.service
sudo systemctl status plexdrive4.service
```

![N](https://image.ibb.co/cVBFFm/Snip20171021_2.png)

- Press CTRL + C to exit the status message

## Final Tips
- You should get a GREEN Light on the service
- I would let it JUST finish before doing ANYTHING! The screen command allows it to finish incase you close terminal
- I would do a reboot AFTER to make sure your /mnt/plexdrive4 works! If you didn't finish the scan, you may have issues
- What I learned is the speed is based on your HD speeds; an SSD is super fast; regular HD can take many hours :D

