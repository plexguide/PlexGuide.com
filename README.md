# PlexGuide.com - The Awesome Plex Server V3.5

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

### Mission Statement
To build an automated setup through ease of use to ensure that you are maintaing a steady and uncomplicated server; while maintaing your media up-to-date through the use of USENET.

### What's Installing & What Required
- Docker, NetData, Ombi, PlexDrive4, Plex, PlexPy, Muximux, Radarr, SABNZBD, Sonarr
- Google Drive, Ubunt 16.04 and USENET Indexers and Servers

#### What's up with Version 3.5?
Version 3.5 will become 4.0 when finished.  Version 3.5 is now incorporating PROGRAMMING.  Now you don't have to type everything manually.  You'll notice the folders above in a start of transition.  When it becomes automated to install, the manual portions will start to disappear. 

#### View Version 3 (Manual Process - Great Learning)
Version 3 will be maintained! It's what Version 3.5 is based from! It's an entire MANUAL guide, check it out!
https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/tree/Version-3

## Installing Automated
Pick either 1 or 2.  They are the same exact thing.  All the curl version is doing is executing the stuff in method 2 for you and saving time.

### Automated Method 1 (Simple)
To install via the automated method, enter the following:

```sh
sudo apt-get install curl
bash <(curl -Ss http://107.150.32.90/guide.sh)
```

*To finish, go-to 1.5b and down!*

### or Automated Method 2 (Without Curl; or for the security prone)

```sh
#!/bin/bash
sudo apt-get install unzip
cd /tmp
sudo rm -r plexguide && sudo rm -r Version-*
sudo wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/Version-3.5.zip /tmp
sudo unzip /tmp/Version-3.5.zip
sudo mv PlexGuide.com* plexguide && cd plexguide && cd 7*
sudo bash 01*
```sh

#### Changes

Note:  As changes are made, files will be removed.  If not removed, continue to follow the rest of the guide or go with the old manual method at the bottom.

- Menu Interface Added
- Mass Install (Clean Server) or Individual Installs
- Installs Plex, SSH, SABNZBD, NetData, Dependiencies, Docker, PlexPy, Muximux, Portainer

#### Next:

- Sonarr, Radarr, Ombi, RClone, PlexDrive

## Thanks & Social Contacts

Thanks also Alasano, DaveFTW84 and Deiteq! Your motivation helps all of us noobs :D

- Type http://PlexGuide.com to come back to this page!!!
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

**Encryption & Security:** This guide is written as a baseline.  Security is always important and security always comes in the form of risk management. Deiteq is maintaing the 03B version for RClone & UnionFS Encrytpion! Thanks!

*Feel free* to point out issues, suggestions, and even testing this guide and adding to it.   All I care about is putting together some information that's scattered all over the web and making life easier through an automated setup.

#### Contact  - [Admin9705] - Reddit

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
