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
