# The Awesome Plex Server V3

Thanks also Alasano, DaveFTW84 and Deiteq! Your motivation helps all of us noobs :D

### Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

#### What's Installing?

CouchPotato, Docker, NetData, Ombi, PlexDrive4, Plex, PlexPy, Muximux, Radarr, SABNZBD, Sonarr

#### What's Required?
Google Drive (G-Suite), Ubuntu 16.04, USENET (torrents a future project).  If your new to all of this, it's fine!

#### Changes from Last Write-Up
 - Less Docker Use
 - UnionFS and bwlimits assist to prevent Google Upload Ban
 - Enables use of server with less disk space due to rclone syncing over prior dependence on rclone mount
 - All services work and no more use of rc.local or cronjobs

**Encryption & Security:** This guide is written as a baseline.  Security is always important and security always comes in the form of risk management.  If you wish to take portions of the guide, re-write; submit it to me (I'll test and credit the portion).  If you only make suggestions, I'll post links at the bottom of the readme.  Ensure that when you read these solutions, that you modify your paths accordingly (including how it is ran).

Deiteq is maintaing the 03B version for RClone & UnionFS Encrytpion! Thanks!

**Note:** This guide is written for a SUDO USER, not ROOT (which may cause some headaches).  The very first portion of the guides you on how to create a SUDO user.

*Feel free* to point out issues, suggestions, and even testing this guide and adding to it.  Full credit will be given.  All I care about is putting together some information that's scattered all over the web and making life easier through an automated setup.

#### Want to Help?:
Take the guide and write up the set of instructions and send a link or SEND A pull request to make it easier!

#### Contact  - [Admin9705] - Reddit

#### Security Solutions:
https://github.com/dweidenfeld/plexdrive/blob/master/TUTORIAL.md - PlexDrive Encyrption (Lin584 - Reddit) 
