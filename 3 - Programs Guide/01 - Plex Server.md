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

## Plex Configuration and Access
Please visit https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Plex-Guide
