# PlexGuide.com - V3.5

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

![N](https://image.ibb.co/b75Hcb/Snip20171104_27.png")

## Manual Process and Manual Guide (for Learning)
http://manual.plexguide.com

## Mission Statement
To build an automated setup through ease of use to ensure that you are maintaing a steady and uncomplicated server; while maintaing your media up-to-date through the use of USENET.

## Purpose
The script installs plex and other programs to create simplistic use.  The script follows the logic of the manual methods, which you can study and learn).  This was made as a result of poor plexcloud performance and Google API bans.  This enables you to have an automated server that upload and downloads with your Google Drive mounted.  Basically, you eliminate all of the hard-drives that are sitting around and you can play from multiple plex servers with the same google mount!

### What's Installing & What Required
- Installing: Docker, NetData, Ombi, PlexDrive4, Plex, PlexPy, Muximux, Radarr, SABNZBD, Sonarr
- Highly Required: Google Drive, Ubunt 16.04 and USENET Indexers and Servers

#### Note
You can install without using Google Drive and without USENET, but you will have to make some of your own adjustments

## Guide Order
(Note: The folders will start to go away as the wiki is built)

- **1.** Read http://wiki.plexguide.com for basic information and understanding
- **2.** Obtain your Google API Key at http://googleapi.plexguide.com
- **3.** Folder 1: Required Processes! (Read & Follow It - It will be automated)
- **4.** Execute the following below:

Install GIT
```sh
sudo apt-get install git
```

To Install PlexGuide
```sh
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
sudo bash /opt/plexg*/ins*
```

To Execute PlexGuide in the future, type:
```sh
plexguide
```

***FYI***

The program has a built-in update manager that you can execute.  At anytime, just type: plexguide.  Select option #3 and the newest files will download for the newest options and updates.

- **5.** When you execute the program, if using G-Drive, execute Part 1. Other storage reasons, not needed.
  - Follow http://plexdrive.plexguide.com for more information! I would highly ... highly recommend it!
- **6.** Configure your programs accordingly with >> http://wiki.plexguide.com
- **7.** Folder 5: (Optional) Build a website front end for your server.

## Thanks & Social Contacts

Thanks also Alasano, DaveFTW84 and Deiteq! Your motivation helps all of us noobs :D

- Type http://PlexGuide.com to come back to this page!!!
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

### Contact  - [Admin9705] - Reddit

### Version Information
- V4   - When programming phase is complete
- V3.5 - *** Current project *** Partially manual and partially automated
- V3   - No programming, learn about the manual process @ http://manual.plexguide.com


### Port Numbers

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
