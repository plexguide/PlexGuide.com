# PlexGuide.com - Version 4

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

![N](https://i.imgur.com/xolIUR4.png)

## Contact Link
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/
- Reddit Contacts - Admin9705 and/or Deiteq

## Mission Statement & Purpose

Establish an automated server that mounts your google drive for storage, while utilizing various tools and Plex as a front-end.  The purpose of this program was to combat the poor performance of the PlexCloud and issues in regards to the Google API Bans.  

## Required

UB 16.04+ & Google Drive (https://gsuite.google.com) (ignore 5 user requirements; unlimited works with 1 user)

## Guide Order - For 4.0 Automated Install

- **1.** Read http://wiki.plexguide.com for basic information and then set up your Google Drive Layout: https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Google-Drive-Layout
- **2.** Obtain your Google API Key at http://googleapi.plexguide.com
- **3.** Execute the following below:

Install GIT
```sh
sudo apt-get install git
```

To Install PlexGuide
```sh
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
sudo bash /opt/plexg*/sc*/ins*
```

To Execute PlexGuide in the future, type:
```sh
plexguide
```

- **4.** Configure RClone
  -  Unencrypt rclone @ http://unrclone.plexguide.com 
  -  Encrypted rclone @ http://enrclone.plexguide.com
- **5.** Configure PlexDrive @ http://plexdrive.plexguide.com          
- **6.** Configure Your Supporting Programs @ http://wiki.plexguide.com
- **7.** Configure Plex @ http://plex.plexguide.com
- **8.** Configure Containers with Portainer: http://portainer.plexguide.com
          
## Final Note

See issues or have solutions? Please post in discussion or REDDIT.  Sometimes other are aware of a problem and it allows us to keep track.  Help make this program better!

## Social Contacts



### What You Can Install

- Port 5050   CouchPotato
- Port 8096   Emby 
- Port 5075   Hydra
- Port 8015   Muximux
- Port 19999  NetData
- Port 3579   Ombiv3
- Port 8020   Organizer
- Port 32400  Plex
- Port 8181   PlexPy
- Port 9000   Portainer
- Port 7878   Radarr
- Port 8085   RuTorrent 
- Port 8989   Sonarr
- Port 8090   SABNZBD
- Port 80     Wordpress

*In Addition Installs* - Docker, PlexDrive, RClone, UnionFS
