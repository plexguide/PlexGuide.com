# PlexGuide.com - Version 4

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

![N](https://preview.ibb.co/j0Vexb/Snip20171111_4.png)

## Thanks & Reddit Link
- Thanks also Alasano, DaveFTW84 and Deiteq (most for encryption)! Your motivation helps all of us noobs :D
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

## Mission Statement & Purpose

Establish an automated server that mounts your google drive for storage, while utilizing various tools and Plex as a front-end.  The purpose of this program was to combat the poor performance of the PlexCloud and issues in regards to the Google API Bans.  

## Required

UB 16.04+ & Google Drive (https://gsuite.google.com) (ignore 5 user requirements; unlimited works with 1 user)

## Guide Order - For 4.0 Automated Install

- **1.** Read http://wiki.plexguide.com for basic information and understanding
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

***FYI***

The program has a built-in update manager that you can execute.  At anytime, just type: plexguide.  Select the update option and the newest files will download for the newest features and fixes.

- **4.** Execute the program follow the steps as followed
        - [1] RClone:
           - Recommended info for unencrypted rclone: http://unrclone.plexguide.com 
           - Recommended info for encrypted rclone  : http://enrclone.plexguide.com
- **5.** [2] Configure PlexDrive - More info at >> http://plexdrive.plexguide.com          
- **6.** [3] Configure your programs accordingly with >> http://wiki.plexguide.com
          - Note: Configuring Plex on a remote machine? Visit: https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Plex-Guide
          - Programs to avoid: RuTorrent, Wordpress & NZBGET (requires fixes and guides) 
- **7.** Configure Docker Programs /w Portainer - Visit http://youripaddress:9000 and select LOCAL (most cases) Now you can manage them!
          - Ensure that when you setup portainer, select REMOTE!
          
## Final Note

See issues or have solutions? Please post in discussion or the REDDIT.  Sometimes other are aware of problems and allows to keep track.  Help make this program better!

## Social Contacts

- Reddit Contact  - [Admin9705] - Reddit

### Version Information
- V4 / Stay on V4 until programming bugs are knocked out!

### What You Can Install
[$$] = No Important, so not ideal to setup until complete

- Port 5050   CouchPotato [$$]
- Port 8096   Emby [$$]
- Port 5075   Hydra [$$]
- Port 8015   Muximux
- Port 19999  NetData
- Port 3579   Ombiv3
- Port 8020   Organizer
- Port 32400  Plex
- Port 8181   PlexPy
- Port 9000   Portainer
- Port 7878   Radarr
- Port 8085   RuTorrent [$$]
- Port 8989   Sonarr
- Port 8090   SABNZBD
- Port 80     Wordpress

*In Addition* - Docker, PlexDrive, RClone, UnionFS
