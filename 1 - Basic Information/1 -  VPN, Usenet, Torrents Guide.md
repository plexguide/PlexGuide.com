Transmission Basics (VPN, Usenet, Torrents)

Intro:  This guide is written for the use of newsgroups only.  You can add torrents, but those solutions must be your own till I catch up to it (which I would highly advise against).

VPN:  A VPN is a virtual private network that is typically encrypted and utilized either to change the location of a service being provided, to hide/and or conceal information, and/or to prevent the interception of information.  From the TRIAD, it provides confidentiality to a limited extent (depends on your provider)

Learn more about VPN’s: https://www.youtube.com/watch?v=K9bhbEm7JAk

# Utilizing USENET

### Question? VPN required for USENET?
USENET does not require a VPN.  Typically if you select port 443 or 563 as your transmission ports, you information is already encrypted.  A VPN does add an extra layer of security, but it can slow down your connection speeds.

USENET has been utilizing since a long time ago back in the day.  It was very confusing, the software was very clunky, the speeds severely capped along with bandwidth usage, and it required a-lot of manual work to get it going.  Some of you reading this were maybe pros back in the day 2001-ish; even prior to that.  Anyways, due to how complicated USENET was, many people chose to use services such as Napster, LimeWire, Kazza and then Torrents as end-state.

With USENET, you can achieve over 1 GIG speeds with 0 sharing (unlike torrents)

The programs you will use are for the following:

Sonarr - TV Shows
Radarr - Movies (New and appears to have same common design of Sonarr, so learning curve is easier.  Small bugs, can crash)
CouchPotato - Movies (existed longer than Radarr, but the complicated v3 interface is something left to be desired)
SABNZBD or NZBGET:  I recommend SABNZBD.  With NZBGET, many of files got lost or the program would just stop or crash.  I tried it over the years, but it’s ok. See the debate of the two on reddit.   

NZB Indexers:  

This is where I first got lost.  With a torrent, you just download the file and call it a day.  

With USENET, the process is a little-bit more complicated.  I call the NZB Indexers the Treasure Map People (my friends get it).  So when Sonarr, Radarr, or CouchPotato is looking for a show/movie, it talks to the treasure map people and says "hey, do you have the treasure map for XY&Z?""  Whichever INDEXER meets the critera of what you are looking for, the managing program then downloads the NZB file from that INDEXER (treasure map).  You're like… man that’s easy.  There is much more regarding USENET.

USENET Servers:  So your managing program now has an NZB file of XY&Z.nzb and you're wondering where the file is.  Well, you have a file, but not the data (sort of like having a torrent).  What you obtained was just the treasure map.  So in this case, the managing program talks to the download program via an API key and passes the information.  So in this case, tv show XY&Z is now being tracked by SABNZBD.  SABNZBD is required to have USENET Servers configured to download the requested files.   

Tip: If utilizing a REMOTE SERVER and you get a timeout, it’s because the NewsGroup blocked the IP your coming from.  It’s due to abuse.  Hetzner is a good remote server, but half of the usenet companies block them due to abuse.

Next, SABNZBD will download the pieces of the file using the TREASURE MAP (NZB Indexer / NZB File) from the beginning and start downloading all of the files (like how utorrent works).  Once downloaded, SABNZBD will store the file to a particular location and then notify the management program (Sonarr,Radarr,CouchPotato) that the file is now downloaded.

he management program (Sonarr/Radarr/CouchPotato) takes the completed file, renames it, and moves it to the location of your choice.  It’s great in that you do not have to move the files yourself (and it prevents garbage files from being uploaded).  When you install rclone,the management programs will automatically place the files in rclone’s upload path.  Basically, your downloaded files are pushed to the cloud automatically.

# Utilizing Torrents

Basic Info:  Torrents are the easiest route to go, but are complicated through the use of automations.  Torrents are not always around, your information is exposed, and it carries a-lot of risk.  Most people select torrents because they are well known, easy to use, and technically free.  What a-lot of people do not realize is that your ip-address is fully displayed for the world to see.  So if you're using torrents, figure out to adapt the programs (not my area), and use a VPN when possible.  If using a VPN, I would use: PIA (Private Internet Access).  PIA is cheap, do not hassle you about multiple collections, take paypal, and I’ve had no problem over the years and being overseas.  Just remember that with any VPN, they can snoop on you.  The free VPN’s, be most wary of.

Learn More About Torrents: https://www.youtube.com/watch?v=OFswNCU5CKA
