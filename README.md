# PlexGuide.com - V3.5

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

![N](https://preview.ibb.co/j0Vexb/Snip20171111_4.png)

## Thanks & Reddit Link
- Thanks also Alasano, DaveFTW84 and Deiteq (most for encryption)! Your motivation helps all of us noobs :D
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

## Mission Statement & Purpose

Establish an automated server that mounts your google drive for storage, while utilizing various tools and Plex as a front-end.  The purpose of this program was to combat the poor performance of the PlexCloud and issues in regards to the Google API Bans.  

## Required

UB 16.04+ & Google Drive (https://gsuite.google.com) (ignore 5 user requirements; unlimited works with 1 user)

## Guide Order - For 3.5 Automated Install

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

- **4.** When you execute the program, if using G-Drive, start with installing PlexDrive.
  - Follow http://plexdrive.plexguide.com for more information! I would highly ... highly recommend it!
- **5.** Configure your programs accordingly with >> http://wiki.plexguide.com
- **6.** Configure Docker Programs /w Portainer - Visit http://youripaddress:9000 and select LOCAL (most cases) Now you can manage them!

## Social Contacts

- Reddit Contact  - [Admin9705] - Reddit

### Version Information
- V4   / When automations are complete
- V3.5 / *** Current project *** Partially manual and partially automated

### What You Can Install

- Port 8015   Muximux
- Port 19999  NetData
- Port 3579   Ombi
- Port 32400  Plex
- Port 8181   PlexPy
- Port 9000   Portainer
- Port 7878   Radarr
- Port 8085   RuTorrent
- Port 8989   Sonarr
- Port 8090   SABNZBD
- Port 80     Wordpress

*In Addition* - Docker, PlexDrive, RClone, UnionFS
