![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)


# Install SABNZBD

![N](https://image.ibb.co/eTqWD6/Snip20171029_12.png)

## Building Your Folders

```sh
### Can Copy & Paste All 7 Lines at Once
sudo mkdir /mnt/sab
sudo mkdir /mnt/sab/nzb
sudo mkdir /mnt/sab/complete
sudo mkdir /mnt/sab/complete/tv
sudo mkdir /mnt/sab/complete/movies
sudo mkdir /mnt/sab/incomplete
```

## Installing SABNZBD Software (Recommended)

```sh
### Warning, add each line on-by-one : Mass copy will result in service errors
sudo apt install sabnzbdplus
sudo add-apt-repository ppa:jcfp/nobetas
sudo apt update
sudo apt install sabnzbdplus
```

## If you want the BETAS (Optional)
 
```sh
### Warning, add each line on-by-one : Mass copy will result in service errors
sudo apt install sabnzbdplus
sudo add-apt-repository ppa:jcfp/ppa
sudo apt-get update
sudo apt install sabnzbdplus
```

## Creating a service for SABNZBD

```sh
sudo nano /etc/systemd/system/sabnzbd.service
```

```sh
[Unit]
Description=SABnzbd Usenet Client
After=multi-user.target

[Service]
Type=simple
User=root
Group=root

ExecStart=/usr/bin/python -OO /usr/bin/sabnzbdplus --server 0.0.0.0:8090 --browser 0 &
ExecStop=/usr/bin/pkill sabnzbdplus
RemainAfterExit=yes
SyslogIdentifier=SABnzbd Usenet Client

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X and [Enter to Save]

## Enable and start the service

```sh
sudo systemctl daemon-reload
sudo systemctl enable sabnzbd.service
sudo systemctl start sabnzbd.service
sudo systemctl status sabnzbd.service
```
- Press CTRL+C to escape the service message

- Lesson Learned
  - If you screw it up, run "sudo system stop sabnzbd.service"... make changes, and then run the 4 lines above again

- Testing
  - Goto http://ipv4address:8090 and make sure it's working!

## SABNZBD Additional Required Installs

```sh
sudo add-apt-repository ppa:jcfp/sab-addons
sudo apt-get update
sudo apt-get install par2-tbb
sudo apt-get install par2-mt
sudo apt-get install python-sabyenc
sudo systemctl restart sabnzbd.service
```

## Configure SABNZBD
Please visit our wiki at https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/SABNZBD-Guide
