# Ombi v3
Is an Open Beta

- V2 always crashes and is unstable; recommend this... much better but has issues until completed at times. No MONO required!
- Please donate to Jamie - https://www.paypal.me/PlexRequestsNet
- https://github.com/tidusjar/Ombi
- Goto https://ci.appveyor.com/project/tidusjar/requestplex/branch/DotNetCore/artifacts
- Right click the Linux.tar.gz (copy and paste - you need it for wget below)

## Create Directory, DL, and Unzip Ombi
```sh
sudo apt-get install libunwind8
sudo mkdir /opt/Ombi && cd /opt/Ombi
sudo wget <going to link from above>
sudo tar -xzf linux.tar.gz
sudo chmod 755 Ombi
```

## Create Ombi Service

### Creating a service for Sonnar
sudo nano /etc/systemd/system/ombi.service

- Copy & Paste the Information Below

```sh
[Unit]
Description=Ombi
After=multi-user.target

[Service]
User=root
Group=root
Type=simple
WorkingDirectory=/opt/Ombi/
ExecStart=/opt/Ombi/Ombi
TimeoutStopSec=20
KillMode=process
Restart=on-failure
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

- Press CTRL+X to exit and save

- Start the Ombi v3 Service

```sh
sudo systemctl daemon-reload
sudo systemctl enable ombi.service
sudo systemctl start ombi.service
sudo systemctl status ombi.service
```

- Press CTRL+C to exit status message
- To test, goto your http://ipv4address:5000 (Give it up-to 3 minutes)
- To see status of it loading, type: sudo systemctl status ombi.service (or ombi3.service)

## Update Ombi if it Fails to Update (Optional)

- Goto https://ci.appveyor.com/project/tidusjar/requestplex/branch/DotNetCore/artifacts
- Right click the Linux.tar.gz (copy and paste - you need it for wget below)

```sh
sudo cp /opt/Ombi/Ombi.db /tmp/
sudo systemctl stop ombi.service
sudo rm -r /opt/Ombi/
sudo mkdir /opt/Ombi && cd /opt/Ombi
sudo wget <copied link>
sudo tar -xzf linux.tar.gz
sudo rm - r /opt/Ombi/Ombi.db
cd /tmp
sudo cp Ombi.db /opt/Ombi/Ombi.db
sudo rm -r /tmp/Ombi.db
sudo chmod 755 Ombi
sudo systemctl start ombi.service
sudo systemctl status ombi.service
```

- Press CTRL+C to exit status message
