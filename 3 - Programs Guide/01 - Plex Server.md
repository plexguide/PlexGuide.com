![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# Plex Install

## Downloading Plex
- Goto https://www.plex.tv/downloads/
- Push the download button (or scroll to the bottom)
- Pick your version if you have PLEX PASS
- Select Linux
- Click [Choose Distribution]
- When you [HOVER] over the Ubuntu 64 version, [RIGHT CLICK] and COPY the Address in a notepad or something
- Bring up terminal and type the following

```sh
cd /tmp 
sudo wget (the address you copied)
```

#### Example

```sh
sudo wget https://downloads.plex.tv/plex-media-server/1.9.3.4290-9798172d4/plexmediaserver_1.9.3.4290-9798172d4_amd64.deb
```

- Note: If you get an address not found, it's because most likely you didn't copy the ENTIRE ADDRESS

## Installing Plex

```sh
sudo dpkg -i plex*
```

## Plex Setup

If you can ACCESS the PLEX SERVER directly such as through a direct interface or on a virutal machine; skip the tunneling instructions

#### Required
- Windows Machine & Putty
- MAC Users - You'll need to find your own solution.  VMWare with Window is great for MAC Users.

### Windows Tunnel with Putty
- Load putty
- Type in your remote-ipaddress and port 22 and select SSH
- On the left side of the menu expand CONNECTION > SSH > Tunnels
  - Source Port: 6969
  - Destination: remote-ipaddress:32400
  - [Click] Open
  - Login and keep the terminal putty open

### Linux Tunnel 
- Source: https://www.howtogeek.com/168145/how-to-use-ssh-tunneling
- Open command line terminal
- Use 'ssh -L local_port:remote_address:remote_port username@server.com' to access remote server
- ssh -L 6969:xxx.xxx.xxx.xxx:32400 bob@ipv4address or bob@xdomain.com

## Open your browser (Chrome best choice)
- Type: 
  - http://localhost:6969/web or (if you forget the web part, you will get a whole bunch of XML garbage)
- You will now be able to setup PLEX
- Double check by opening a new window or tab and type http://ipv4address:32400/web

## Plex Optimizaiton

### Configuring TV Shows 
- [Click] Add Library
- [Click] TV Shows
- [Type] Add Folders to Your Library: /mnt/plexdrive4/zilch/tv
  - Note: You will never be able to select it; type it and hit ok
- [Click] Ok

### Configuring Movies 
- [Click] Add Library
- [Click] Films
- [Type] Add Folders to Your Library: /mnt/plexdrive4/zilch/movies
  - Note: You will never be able to select it; type it and hit ok
- [Click] Ok

### Configure Server Settings
- Configure what you need, there is one important area.
- [Click] Server > Show Advanced > Library
- [Keep-Off] Update my library automatically
- [Keep-Off] Run a partical scan...
- [Keep-Off] Include music libraries...
- [Keep-On] Update my library periodically
- [Select] Library update interval: Every 1 hour
- [Keep-On] Empty trash automatically after every scan
- The rest is on you!
