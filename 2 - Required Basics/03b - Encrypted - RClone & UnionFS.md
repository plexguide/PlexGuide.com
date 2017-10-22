# Encrypted - RClone, UnionFS & Move 
#### (Maintained By - Deiteq)
WARNING - Chose Either 03A or 03B

- RClone
  - Mounts your Google Drive (not used as primary due to API Bans)
- UnionFS
  - Moves multiple drives
- Move
  - Made to sync files from your local drive to your google drive

## Setting Up & Installing RClone

```sh
### Creating Folders
sudo mkdir /mnt/rclone-union
sudo mkdir /mnt/rclone-move
sudo mkdir /mnt/rclone-move/tv
sudo mkdir /mnt/rclone-move/movies

### Chaning Permissions
sudo chmod 755 /mnt/rclone-move && sudo chmod 755 /mnt/rclone-union

## To Install Fuse
sudo apt-get install unionfs-fuse

## Installing RClone (Can Copy Entire and Execute Entire Mini Block Below)

cd /tmp
sudo curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
sudo unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb
cd .. && sudo rm -r rclone*
sudo mkdir /mnt/rclone
sudo chmod 755 /mnt/rclone
sudo chown root /mnt/rclone
```

Configure RClone config as Root 

```sh
sudo su
rclone config
```

## Configuring RClone
May change due to version | Currently for version 1.38

- N < For New remote 
- gdrive < for the name
- 9 < For Google Drive (double check the number select incase)
- Enter Your Google ID
- Enter Your Goole Secret
- N < for headless machine #### NOTE: if your on a VM or the actual machine with an interface (GUI), select Y.  
- Enter Your Verification Code
-   Note: If you copy and paste by SELECTING and CLICK the RIGHT Mouse button, it will work; but then you will see it repeat
-   Note: Hold the DEL button to del the extra crap and then paste into a browser to get the verfication code
- N < Configure this as a team drive?
- Y < If asking all is ok?

```sh
This encrypted mount will be used for the rclone-move.sh found later in these instructions
```

- N < For New remote 
- gcrypt < for the name
- 6 < For Encrypt/Decrypt (double check the number select incase)
- gdrive:/encrypt (encrypt being the rclone encrypted folder within your gdrive)
- 2 < Encrypt standard
- Y < type your own password (make up a secure one and write it down somewhere safe otherwise use the one from before if you already created it for whichever original encrypted folder you want to use) 
- Y < type your own salt password (make up a different secure one and write it down somewhere safe otherwise use the one from before if you already created it for whichever original encrypted folder you want to use)
- Should see something like this:

```sh
[gcrypt]
remote = gdrive:/encrypt
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***
```

- Y < If asking all is ok?

```sh
### This encrypted mount will be for unionfs.service to avoid bans
```

- N < For New remote 
- crypt < for the name
- 6 < For Encrypt/Decrypt (double check the number select incase)
- /mnt/plexdrive4/encrypt (encrypt being the rclone encrypted folder within your gdrive)
- 2 < Encrypt standard
- Y < type your own password (use the same password as above for gcrypt) 
- Y < type your own salt password (use the same SALT password as above for gcrypt)
- Should see something like this:

```sh
[crypt]
remote = /mnt/plexdrive4/encrypt
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***
```

- Y < If asking all is ok?
- N < For New remote
- local < for the name
- 11 < For a Local Drive
- /mnt/rclone-move
- Y < If asking all is ok?
- Q < to quit

# back to your username
su [YOURUSERNAME]

sudo nano /etc/fuse.conf
# remove the (#) symbol before user_allow_other; then press CTRL+X and then save

### Create RClone Service for unionfs.service
sudo nano /etc/systemd/system/rclone.service

##### START COPY #####

[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount crypt: /mnt/rclone --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
 
[Install]
WantedBy=multi-user.target

##### END COPY #####
# Press CTRL+X and then Yes to save

### Start and enable the service
sudo systemctl daemon-reload
sudo systemctl enable rclone.service
sudo systemctl start rclone.service
sudo systemctl status rclone.service
# Press CTRL + C to exit the status message
################# RClone ################# END

### Create encrypted RClone Service for rclone-move.sh
sudo nano /etc/systemd/system/rclone-crypt.service

##### START COPY #####

[Unit]
Description=RClone Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/rclone --allow-non-empty --allow-other mount gcrypt: /mnt/rclone-crypt --bwlimit 8650k --size-only
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
 
[Install]
WantedBy=multi-user.target

##### END COPY #####
# Press CTRL+X and then Yes to save

### Start and enable the service
sudo systemctl daemon-reload
sudo systemctl enable rclone-crypt.service
sudo systemctl start rclone-crypt.service
sudo systemctl status rclone-crypt.service
# Press CTRL + C to exit the status message
################# RClone Crypt ################# END

## Establishing unionfs.service

- Merges your local drive and plexdrive to create a secondary drive
- Required for Sonarr & Radarr

```sh
sudo nano /etc/systemd/system/unionfs.service
```

- Copy and paste the following below for the unionfs.service

```sh
[Unit]
Description=UnionFS Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/usr/bin/unionfs -o allow_other,nonempty /mnt/rclone-move=RW:/mnt/rclone=RO /mnt/rclone-union
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X and then Yes to save

### Start and enable unionfs.service
```sh
sudo systemctl daemon-reload
sudo systemctl enable unionfs.service
sudo systemctl start unionfs.service
sudo systemctl status unionfs.service
```

## Establishing the move.service

- This results in your files being upload from your local drive to google drive
- Do not increase the bwlimit past 10M. 8M is a safe number to prevent a Google Upload Drive API Ban.

### Create a Script

```sh
sudo nano /opt/rclone-move.sh
```

- Copy and paste the following into the script

```sh
#!/bin/bash

while true
do
# Purpose of sleep starting is so rclone has time to startup and kick in
sleep 30
# Anything above 8M will result in a google ban if uploading above 8M for 24 hours
rclone move --bwlimit 8M --tpslimit 4 --max-size 99G --log-level INFO --stats 15s local:/mnt/rclone-move gdrive:/
sleep 270
done
```

- Press CTRL+X and ENTER 

### Script permissions

- Allows the script to execute when called upon by the move.serivce

```sh
sudo chmod 755 /opt/rclone-move.sh
```

## Create move.service
- Helps move your files from your local drive to your Google Drive

```sh
sudo nano /etc/systemd/system/move.service
```
- Copy and paste the following into the move.service

```sh

[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/rclone-move.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X and then Yes to save

### Start and enable the move.service

```sh
sudo systemctl daemon-reload
sudo systemctl enable move.service
sudo systemctl start move.service
sudo systemctl status move.service
```

- Press CTRL + C to exit the status message
