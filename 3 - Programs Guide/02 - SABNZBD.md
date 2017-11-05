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
- SAB for TV - http://ipv4address:8090
- Wizard Mode - You can start filling or do later
- Configuration
- [Click] Gear Icon (Upper Right) > [Click] Gear Icon (Upper Left)
- SAnzbd Web Server Area
  - Web Interface: Glitter - Night (forces to get rid of old interface if you have it)
- General Area
  - SABnzbd Username: (remember it)
  - SABnzbd Password: (remember it)
  - External Internet Access: Full Web Interface - Only External Access...
  - [Click] Save changes and click the folder icon at the top
- Folder Area
  - Temporary Download Folder: /mnt/sab/incomplete
  - Minimum Free Space: 100GB (whatever is best for you)
  - Completed Download Folder: /mnt/sab/complete
  - Permissions for completed downloads: 777
  - .nzb Backup Folder: /mnt/sab/nzb
  - [Click] Save changes and click the double arrow icons at the top
- Servers Area
  - Host: The name the service provides you; not what you think it is
  - Port: 119, 443, or 563.  563 or 443 are best choices due to encryption
  - SSL: Check mark only if 563 or 443 are selected.  If you forget, it will not connection with 563 or 443
  - Username & Password:  Keep it stored somewhere or you will go nuts with password resets
    - Recommend using Google Keep (http://keep.google.com) or Apple's iCloud Notes (http://icloud.com)
  - Connections:  Stay 2 or 3 under your max.  If exact, you will get errors
  - Priority: Leave this alone unless you know what you area doing
  - [Click] Test Server
  - [Fails] Something stupid. Either the SSL, wrong port, wrong username, and etc
  - [Passes] Click the (Add Server) and then click the checkmark box at the top
- Categories Area
  - For TV, paste/type this in the folder path: tv
  - [Hit Save to the Right]
  - For Movies, paste/type this in the folder path: movies
  - [Hit Save to the Right]
- Switches Area
  - Detect Duplicate Downloads:  Fail Job (Move to History)
  - Action when encrypted Rar is downloaded: Abort
  - Action when unwanted extension is detected: Abort
  - Unwanted etensions: exe, com, bat, sh
  - Direct Unpack:  Check [ON]
  - Ignore any Folders inside archives:  Check the Box - [ON]
  - On failure, try alternative NZB:  Check the BOX [ON]
  - Ignore Samples:  Check the BOX [ON]
  - Cleanup List: nfo, exe, com, bat, txt, doc, xls, xlxs, docx, doc, jpg, jeg, gif, png
  - Replace dots in folder name:  Check the BOX [ON]
  - [Click] Save Changes
