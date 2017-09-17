# The Awesome Plex  Server

Reddit Link (Great for Discussion): https://www.reddit.com/r/AwesomePlex/

Need the old link for your STABLE current setup? https://github.com/Admin9705/The-Awesome-Plex-Server/tree/master

# Welcome to the Awesome Plex Server V3 (BETA)

#### What's Installing?

Ready:      CouchPotato, NetData, PlexDrive4, Plex, Radarr, SABNZBD, Sonarr

Not Ready:  APACHE,  PlexPy, Muximux, MYSQL , & Wordpress

Future:     Torrent Intergration & Security

#### What's Required?
Google Drive (G-Suite), Ubuntu 16.04, USENET (torrents a future project).  If your new to all of this, it's fine!

#### Why the Changes?
Docker is great, but it's a pain for this setup.  The problem with docker is that there are permission issue, path issues, update issues... on and on.  It's hard to troubleshoot items also.  In my first go around prior to Docker, I had problems restarting programs and did not understand how to utilize service correctly; well all of that is now fixed.  Now having the ability to reboot the programs and all of them enabled with services, this is no longer and issue.

**Encryption & Security:** This guide is written as a baseline.  Security is always important and security always comes in the form of risk management.  If you wish to take portions of the guide, re-write; submit it to me (I'll test and credit the portion).  If you only make suggestions, I'll post links at the bottom of the readme.  Ensure that when you read these solutions, that you modify your paths accordingly (including how it is ran).

**Note:** This guide is written for a SUDO USER, not ROOT (which may cause some headaches).  The very first portion of the guides you on how to create a SUDO user.

*Feel free* to point out issues, suggestions, and even testing this guide and adding to it.  Full credit will be given.  All I care about is putting together some information that's scattered all over the web and making life easier through an automated setup.

#### Want to Help?:
Take the guide and write up the set of instructions and send a link.  I'll post the credit to you (and test of course).

#### Contact  - [Admin9705] - Reddit

### Solutions for PlexDrive and RClone
https://github.com/madslundt/docker-cloud-media-scripts - Asked author for idea to incorporte his ideas to make the process easier.  PlexDrive and RClone are mainly the last two items; which are not dockered.

#### Additional Solutions
Installing LAMP Stack: https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04

#### Security Solutions:
https://github.com/dweidenfeld/plexdrive/blob/master/TUTORIAL.md - PlexDrive Encyrption (Lin584 - Reddit) 
