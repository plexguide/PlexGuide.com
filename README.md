# The Awesome Plex  Server

Want to access the old guide with pictures? http://doc.plexguide.com (Warning Semi Dated / good for pictures / bad for install)

This guide will enable you to run a plex service, create and run many mass programs at once, and download-upload utilizing USENET.  This fully works on my server with minimimal maintence.  Incorporates the full power of Docker (you'll like it if you get VMWare).  

Why Docker?  I didn't understand what Docker was until I did some research.  Basically, think of Docker as manager program that create mini vm's in what's known as containers.  Each container runs within it's own environment with all the dependices installed.  If lets say plex goes down; you do not have to reboot the entire server; your reboot only the container called plex.  You can manage your containers when you install portainer.

Encryption & Security: This guide is written as a baseline.  Security is always important and security always comes in the form of risk management.  If you wish to take portions of the guide, re-write; submit it to me (I'll test and credit the portion).  If you only make suggestions, I'll post links at the bottom of the readme.  Ensure that when you read these solutions, that you modify your paths accordingly (including how it is ran).

Recommend to install PlexDrive 4.  Wrote up this guide that allows an easy install of both. PD4 right now is working 100x better than PD5 in my use (and another confirmed by a user who did the same).  The YML is written up so all you have to do is change a number and your Plex won't even notice (it's a good thing).

Note: This guide is written for a SUDO USER, not ROOT (which may cause some headaches).  The very first portion of the guides you on how to create a SUDO user.

Why 2 instances of SAB?  You could just do one, but it's much easier to have two.  One for movies and one for tv shows.  It prevents one from backlogging on too many movies or too many tv shows and if one goes down, the other is still up and running.  Trust me on this.

The Following Items Will Be Installed:

  - Plex & PlexyPy & Ombi
  - RClone & PlexDrive 4
  - Docker, Docker Compose, and Portainer
  - Sonarr & Radarr, CouchPotato + 2 Instances of SABNZBD; one for each
  - NetData & MuxiMux

The Awesome Plex Server Is Based on the USE OF:

  - Ubuntu 16.04
  - Google Drive (G-Suite)
  - If Downloading - USENET
  - Remote Server; works for local also (use dyndns and a ddwrt router to access your service outside of your local server)

# Who It's Written For:

  - For Noobs and Novice Noobs like me
  - For those who just want to learn and/or improve their setup


Not For:
  - Cranky Linux Experts
  - Closed Minded Individuals
  - Non-Solution Oriented Anti-Team Personality Types

Feel free to point out issues, suggestions, and even testing this guide and adding to it.  Full credit will be given.  All I care about is putting together some information that's scattered all over the web and making life easier through an automated setup.

# Want to Help?:

Take the guide and write up the set of instructions and send a link.  I'll post the credit to you (and test of course).

### Contact

* [Admin9705] - Reddit

### Requested Help
  - Typos or something does not make sense
  - Cleaning up code
  - Using APIs instead of blackhole (cannot get past docker limitation on this; it's regarding importing of files)

### Additional Solutions
Installing LAMP Stack: https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04

### Security Solutions:

https://github.com/dweidenfeld/plexdrive/blob/master/TUTORIAL.md - PlexDrive Encyrption (Lin584 - Reddit) 


