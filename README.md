# PlexGuide.com - V3.5

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

![N](https://preview.ibb.co/bP2Wnb/Snip20171105_31.png")

## Manual Process and Manual Guide (for Learning) & Thanks
- http://manual.plexguide.com 
- Thanks also Alasano, DaveFTW84 and Deiteq (most for encryption)! Your motivation helps all of us noobs :D

## Mission Statement
Build an automated setup to ensure that you are maintaing a steady and reliable server, while maintaing your media is up-to-date (especially through the use of USENET - speed and security over torrents).

## Purpose
Installs Plex and other programs. This was made as a result of poor plexcloud performance and Google API bans. This allows you to maintain an automated server that uploads and downloads your files through the use of a mounted google drive. 

## Guide Order

- **1.** Read http://wiki.plexguide.com for basic information and understanding
- **2.** Obtain your Google API Key at http://googleapi.plexguide.com
- **3.** Execute Manual RClone Portion (Working to Automate, somewhat tricky to program) **(Select Only 1)**
    - **a.** Unencrypted RClone: http://unrclone.plexguide.com
    - **b.** Encrypted RClone  : http://enrclone.plexguide.com
- **4.** Execute the following below:

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

The program has a built-in update manager that you can execute.  At anytime, just type: plexguide.  Select option #3 and the newest files will download for the newest options and updates.

- **5.** When you execute the program, if using G-Drive, start with installing PlexDrive.
  - Follow http://plexdrive.plexguide.com for more information! I would highly ... highly recommend it!
- **6.** Configure your programs accordingly with >> http://wiki.plexguide.com
- **7.** Configure Docker Programs /w Portainer - Visit http://youripaddress:9000 and select LOCAL (most cases) Now you can manage them!

## Social Contacts

- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/
- Reddit Contact  - [Admin9705] - Reddit

### Version Information
- V4   - When programming phase is complete
- V3.5 - *** Current project *** Partially manual and partially automated
- V3   - No programming, learn about the manual process @ http://manual.plexguide.com

### What You Can Install

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
- Port 80     Wordpress

*In Addition* - Docker, PlexDrive, RClone, UnionFS
