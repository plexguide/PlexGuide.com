# PlexGuide.com - The Awesome Plex Server V3

![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

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

**Encryption & Security:** This guide is written as a baseline.  Security is always important and security always comes in the form of risk management.  If you wish to take portions of the guide, re-write; submit it to me (I'll test and credit the portion).  If you only make suggestions, I'll post links at the bottom of the readme.  Ensure that when you read these solutions, that you modify your paths accordingly (including how it is ran).

Deiteq is maintaing the 03B version for RClone & UnionFS Encrytpion! Thanks!

**Note:** This guide is written for a SUDO USER, not ROOT (which may cause some headaches).  The very first portion of the guides you on how to create a SUDO user.

*Feel free* to point out issues, suggestions, and even testing this guide and adding to it.  Full credit will be given.  All I care about is putting together some information that's scattered all over the web and making life easier through an automated setup.

#### Want to Help?:
Take the guide and write up the set of instructions and send a link or SEND A pull request to make it easier!

#### Contact  - [Admin9705] - Reddit

## Semi Good News for Windows Users! 
So prior to building all of this, there was NO good solution running a G-Suite / Windows Plex Server due to API Bans. http://www.netdrive.net now released version 3 and I purchased an upgraded license and it works with 0 API bans.  It creates a network or drive that mounts your gsuite to your windows machine!  I had plex scan and 0 issues with API bans.  You make the drive writeable and readable.  I would recommend that it's just used for PLEX.  If using for Couch/Sonnar/Radarr; you can... but do so with light downloading because the cache will overwhelm your drive if backlogged and there are no bandwidth limit controls (750GB per day upload is the only issue).  So, I run a linux version (Awesome Plex Server) that does all of the work and a secondary plex server with netdrive! If you had netdrive 2, it was somewhat buggy and slow, but they truly revamped everything! There is a one month trial. I received nothing for this and just wrote this as FYI because it works (it is not an affiliate, nor commission thing).  

- Windows Issue 1: May disconnect if you you have radarr/couch/sonnar pointing to it.

- MAC version: Do not use at all.  Disconnects very easily.
