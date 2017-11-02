# PlexGuide.com - The Awesome Plex Server V3.5

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# What's up with Version 3.5?
Version 3.5 will become 4.0 when finished.  Version 3.5 is STARTNIG to incorporate PROGRAMMING.  Now you don't have to type 

# View Version 3 (Manual Process - Great Learning)
Version 3 will be maintained! It's what Version 3.5 is based from!
https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/tree/Version-3

# Automated Method

To install via the automated method, enter the following:

```
sudo apt-get install unzip
cd /tmp
sudo rm -r plexguide && sudo rm -r Version-*
sudo wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/Version-3.5.zip /tmp
sudo unzip /tmp/Version-3.5.zip
sudo mv PlexGuide.com* plexguide && cd plexguide && cd 7*
sudo bash 01*
```

## Changes

Note:  As changes are made, files will be removed.  If not removed, continue to follow the rest of the guide or go with the old manual method at the bottom.

- Menu Interface Added
- Mass Install (Clean Server) or Individual Installs
- Installs Plex, SSH, SABNZBD, NetData, Dependiencies

## Next:

- Sonarr, Radarr, Docker & Containers

## Thanks & Social Contacts

Thanks also Alasano, DaveFTW84 and Deiteq! Your motivation helps all of us noobs :D

- Type http://PlexGuide.com to come back to this page!!!
- Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

#### What's Installing?

CouchPotato, Docker, NetData, Ombi, PlexDrive4, Plex, PlexPy, Muximux, Radarr, SABNZBD, Sonarr

#### What's Required?
Google Drive (G-Suite), Ubuntu 16.04, USENET (torrents a future project).  If your new to all of this, it's fine!

#### Changes from Last Write-Up
 - Less Docker Use
 - UnionFS and bwlimits assist to prevent Google Upload Ban
 - Enables use of server with less disk space due to rclone syncing over prior dependence on rclone mount
 - All services work and no more use of rc.local or cronjobs

**Encryption & Security:** This guide is written as a baseline.  Security is always important and security always comes in the form of risk management. Deiteq is maintaing the 03B version for RClone & UnionFS Encrytpion! Thanks!

*Feel free* to point out issues, suggestions, and even testing this guide and adding to it.   All I care about is putting together some information that's scattered all over the web and making life easier through an automated setup.

#### Contact  - [Admin9705] - Reddit
