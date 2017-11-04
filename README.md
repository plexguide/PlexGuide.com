# PlexGuide.com - The Awesome Plex Server V3.5

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

## Mission Statement
To build an automated setup through ease of use to ensure that you are maintaing a steady and uncomplicated server; while maintaing your media up-to-date through the use of USENET.

## Purpose
The script installs plex and other programs to create simplistic use.  The script follows the logic of the manual methods, which you can study and learn).  This was made as a result of poor plexcloud performance and Google API bans.  This enables you to have an automated server that upload and downloads with your Google Drive mounted.  Basically, you eliminate all of the hard-drives that are sitting around and you can play from multiple plex servers with the same google mount!

### What's Installing & What Required
- Docker, NetData, Ombi, PlexDrive4, Plex, PlexPy, Muximux, Radarr, SABNZBD, Sonarr
- Google Drive, Ubunt 16.04 and USENET Indexers and Servers

### Version Information
- V4   - When programming phase is complete
- V3.5 - *** Current project *** Partially manual and partially automated
- V3   - No programming, learn about the manual process @ https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/tree/Version-3

## Guide Order
(Note: The folders will start to go away as the wiki is built)

- 1. Folder 1: FYI reading material.
- 2. Folder 2: Manual Required Processes! (Read & Follow - will be automated)
- 3. Execute the following below:

```sh
sudo apt-get install git
sudo rm -r /tmp/plexg* 2>/dev/null
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /tmp/plexguide
sudo bash /tmp/plex*/s*/ma*
```

- 4. Read the wiki pages to configure your programs accordingly!
  - http://wiki.plexguide.com
- 5. Folder 5: (Opitional) Build a website front end for your server.

## Thanks & Social Contacts

Thanks also Alasano, DaveFTW84 and Deiteq! Your motivation helps all of us noobs :D

- Type http://PlexGuide.com to come back to this page!!!
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

## Contact  - [Admin9705] - Reddit

## Port Numbers

- Port 8015   Muximux
- Port 19999  NetData
- Port 3579   Ombi
- Port 32400  Plex
- Port 8181   PlexPy
- Port 9000   Portainer
- Port 5050   CouchPotato
- Port 7878   Radarr 
- Port 8989   Sonarr
- Port 8090   SABNZBD
