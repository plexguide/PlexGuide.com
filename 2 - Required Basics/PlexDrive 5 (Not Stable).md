# PlexDrive5
Establishes a read-only file system to prevent API bans with plex.  PD5 uses RAM instead of diskspace

## Install PlexDrive5
```sh
cd /tmp
sudo wget https://github.com/dweidenfeld/plexdrive/releases/download/5.0.0/plexdrive-linux-amd64
sudo mv plexdrive-linux-amd64 plexdrive5
sudo mv plexdrive5 /usr/bin/
cd /usr/bin/
sudo chown root:root /usr/bin/plexdrive5
sudo chmod 755 /usr/bin/plexdrive5
sudo mkdir /mnt/plexdrive5 && sudo chmod 755 /mnt/plexdrive5
cd ~
```
### Execute PlexDrive
Let Plex5 Run! Do not do anything else unless completed!

```sh
sudo screen plexdrive5 mount --uid=0 --gid=0 -o allow_other -v2 --max-chunks=200 /mnt/plexdrive5
```

### Creating a service for PlexDrive5

```sh
sudo nano /etc/systemd/system/plexdrive5.service
```

- Copy & Paste into the File!

```sh
[Unit]
Description=PlexDrive5 Service
After=multi-user.target

[Service]
Type=simple
sudo screen plexdrive5 mount --uid=0 --gid=0 -o allow_other -v2 --max-chunks=200 /mnt/plexdrive5
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
sudo systemctl enable plexdrive5.service
sudo systemctl start plexdrive5.service
sudo systemctl status plexdrive5.service
```

![N](https://image.ibb.co/cVBFFm/Snip20171021_2.png)

- Press CTRL + C to exit the status message

## Final Tips
- You should get a GREEN Light on the service
- I would let it JUST finish before doing ANYTHING! The screen command allows it to finish incase you close terminal
- I would do a reboot AFTER to make sure your /mnt/plexdrive5 works! If you didn't finish the scan, you may have issues
- What I learned is the speed is based on your HD speeds; an SSD is super fast; regular HD can take many hours :D

